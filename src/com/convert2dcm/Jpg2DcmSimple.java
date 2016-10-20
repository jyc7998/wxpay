
package com.convert2dcm;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Properties;


import org.dcm4che2.data.BasicDicomObject;
import org.dcm4che2.data.DicomObject;
import org.dcm4che2.data.Tag;
import org.dcm4che2.data.UID;
import org.dcm4che2.data.VR;
import org.dcm4che2.io.DicomOutputStream;
import org.dcm4che2.util.UIDUtils;

public class Jpg2DcmSimple {

    private static int FF = 0xff;

    private static int SOF = 0xc0;

    private static int DHT = 0xc4;

    private static int DAC = 0xcc;

    private static int SOI = 0xd8;

    private static int SOS = 0xda;
    
    private static int APP = 0xe0;    

    private String charset = "ISO_IR 100";
    
    private String transferSyntax = UID.JPEGBaseline1;
    
    private byte[] buffer = new byte[8192];

    private int jpgHeaderLen;
    
    private int jpgLen;
    
    private boolean noAPPn = false;
    
    private Properties cfg = new Properties();

    public Jpg2DcmSimple() {
        try {
            cfg.load(Jpg2DcmSimple.class.getResourceAsStream("jpg2dcm.cfg"));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    
    public final void setCharset(String charset) {
        this.charset = charset;
    }
    
    public void setDcmCfg(String patID, 
    		String studyUID, String Modality)
    {
	cfg.setProperty("00100020", patID);
	cfg.setProperty("0020000D", studyUID);
	cfg.setProperty("00080060", Modality);  	
}   
    
    public void convert(File jpgFile, File dcmFile) throws IOException {
        jpgHeaderLen = 0;
        jpgLen = (int) jpgFile.length();
        DataInputStream jpgInput = new DataInputStream(
                new BufferedInputStream(new FileInputStream(jpgFile)));
        try {
            DicomObject attrs = new BasicDicomObject();
            attrs.putString(Tag.SpecificCharacterSet, VR.CS, charset);
            for (Enumeration en = cfg.propertyNames(); en.hasMoreElements();) {
                String key = (String) en.nextElement();
                int[] tagPath = Tag.toTagPath(key);                
                int last = tagPath.length-1;
                VR vr = attrs.vrOf(tagPath[last]);
                if (vr == VR.SQ) {
                    attrs.putSequence(tagPath);
                } else {
                    attrs.putString(tagPath, vr, cfg.getProperty(key));
                }
            }
            if (noAPPn || missingRowsColumnsSamplesPMI(attrs)) {
                readHeader(attrs, jpgInput);
            }
            ensureUS(attrs, Tag.BitsAllocated, 8);
            ensureUS(attrs, Tag.BitsStored, attrs.getInt(Tag.BitsAllocated));
            ensureUS(attrs, Tag.HighBit, attrs.getInt(Tag.BitsStored) - 1);
            ensureUS(attrs, Tag.PixelRepresentation, 0);
            ensureUID(attrs, Tag.StudyInstanceUID);
            ensureUID(attrs, Tag.SeriesInstanceUID);
            ensureUID(attrs, Tag.SOPInstanceUID);
            Date now = new Date();
            attrs.putDate(Tag.InstanceCreationDate, VR.DA, now);
            attrs.putDate(Tag.InstanceCreationTime, VR.TM, now);
            attrs.initFileMetaInformation(transferSyntax);
            FileOutputStream fos = new FileOutputStream(dcmFile);
            BufferedOutputStream bos = new BufferedOutputStream(fos);
            DicomOutputStream dos = new DicomOutputStream(bos);
            try {
                dos.writeDicomFile(attrs);
                dos.writeHeader(Tag.PixelData, VR.OB, -1);
                dos.writeHeader(Tag.Item, null, 0);
                dos.writeHeader(Tag.Item, null, (jpgLen+1)&~1);
                dos.write(buffer, 0, jpgHeaderLen);
                int r;
                while ((r = jpgInput.read(buffer)) > 0) {
                    dos.write(buffer, 0, r);
                }
                if ((jpgLen&1) != 0) {
                    dos.write(0);
                }
                dos.writeHeader(Tag.SequenceDelimitationItem, null, 0);
            } finally {
                dos.close();
            }
        } finally {
            jpgInput.close();            
        }
    }    

    private boolean missingRowsColumnsSamplesPMI(DicomObject attrs) {
        return !(attrs.containsValue(Tag.Rows) 
                && attrs.containsValue(Tag.Columns)
                && attrs.containsValue(Tag.SamplesPerPixel)
                && attrs.containsValue(Tag.PhotometricInterpretation)
                );
    }

    private void readHeader(DicomObject attrs, DataInputStream jpgInput)
            throws IOException {
        if (jpgInput.read() != FF || jpgInput.read() != SOI 
                || jpgInput.read() != FF) {
            throw new IOException(
                    "JPEG stream does not start with FF D8 FF");
        }
        int marker = jpgInput.read();
        int segmLen;
        boolean seenSOF = false;
        buffer[0] = (byte) FF;
        buffer[1] = (byte) SOI;
        buffer[2] = (byte) FF;
        buffer[3] = (byte) marker;
        jpgHeaderLen = 4;
        while (marker != SOS) {
            segmLen = jpgInput.readUnsignedShort();
            if (buffer.length < jpgHeaderLen + segmLen + 2) {
                growBuffer(jpgHeaderLen + segmLen + 2);
            }
            buffer[jpgHeaderLen++] = (byte) (segmLen >>> 8);
            buffer[jpgHeaderLen++] = (byte) segmLen;
            jpgInput.readFully(buffer, jpgHeaderLen, segmLen - 2);
            if ((marker & 0xf0) == SOF && marker != DHT && marker != DAC) {
                seenSOF = true;
                int p = buffer[jpgHeaderLen] & 0xff;
                int y = ((buffer[jpgHeaderLen+1] & 0xff) << 8)
                       | (buffer[jpgHeaderLen+2] & 0xff);
                int x = ((buffer[jpgHeaderLen+3] & 0xff) << 8)
                       | (buffer[jpgHeaderLen+4] & 0xff);
                int nf = buffer[jpgHeaderLen+5] & 0xff;
                attrs.putInt(Tag.SamplesPerPixel, VR.US, nf);
                if (nf == 3) {
                    attrs.putString(Tag.PhotometricInterpretation, VR.CS,
                            "YBR_FULL_422");
                    attrs.putInt(Tag.PlanarConfiguration, VR.US, 0);
                } else {
                    attrs.putString(Tag.PhotometricInterpretation, VR.CS,
                            "MONOCHROME2");
                }
                attrs.putInt(Tag.Rows, VR.US, y);
                attrs.putInt(Tag.Columns, VR.US, x);
                attrs.putInt(Tag.BitsAllocated, VR.US, p > 8 ? 16 : 8);
                attrs.putInt(Tag.BitsStored, VR.US, p);
                attrs.putInt(Tag.HighBit, VR.US, p-1);
                attrs.putInt(Tag.PixelRepresentation, VR.US, 0);
            }
            if (noAPPn & (marker & 0xf0) == APP) {
                jpgLen -= segmLen + 2;
                jpgHeaderLen -= 4;
            } else {
                jpgHeaderLen += segmLen - 2;
            }
            if (jpgInput.read() != FF) {
                throw new IOException("Missing SOS segment in JPEG stream");
            }
            marker = jpgInput.read();
            buffer[jpgHeaderLen++] = (byte) FF;
            buffer[jpgHeaderLen++] = (byte) marker;
        }
        if (!seenSOF) {
            throw new IOException("Missing SOF segment in JPEG stream");
        }
    }

    private void growBuffer(int minSize) {
        int newSize = buffer.length << 1;
        while (newSize < minSize) {
            newSize <<= 1;
        }
        byte[] tmp = new byte[newSize];
        System.arraycopy(buffer, 0, tmp, 0, jpgHeaderLen);
        buffer = tmp;
    }

    private void ensureUID(DicomObject attrs, int tag) {
        if (!attrs.containsValue(tag)) {
            attrs.putString(tag, VR.UI, UIDUtils.createUID());
        }        
    }

    private void ensureUS(DicomObject attrs, int tag, int val) {
        if (!attrs.containsValue(tag)) {
            attrs.putInt(tag, VR.US, val);
        }        
    }    
   
}