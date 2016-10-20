package iu.utils;

import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.spec.SecretKeySpec;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class AsyCryptography {
	private static String key = "pacsaudksKGhmbmhyg";
	
		public String getEncrypt(String content) throws Exception{
			return aesEncrypt(content, this.key);
		}
		
		public String getDecrypt(String content) throws Exception{
			return aesDecrypt(content, this.key);
		}

		private static String aesEncrypt(String content, String encryptKey)
				throws Exception {
			return base64Encode(aesEncryptToBytes(content, encryptKey));
		}

		private static byte[] aesEncryptToBytes(String content, String encryptKey)
				throws Exception {

			KeyGenerator kgen = KeyGenerator.getInstance("AES");
			kgen.init(128, new SecureRandom(encryptKey.getBytes()));

			Cipher cipher = Cipher.getInstance("AES");
			cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(kgen.generateKey().getEncoded(), "AES"));

			return cipher.doFinal(content.getBytes("utf-8"));
		}

		private static String aesDecrypt(String encryptStr, String decryptKey)
				throws Exception {
			return encryptStr.isEmpty() ? null : aesDecryptByBytes(
					base64Decode(encryptStr), decryptKey);
		}

		private static String aesDecryptByBytes(byte[] encryptBytes,
				String decryptKey) throws Exception {
			KeyGenerator kgen = KeyGenerator.getInstance("AES");
			kgen.init(128, new SecureRandom(decryptKey.getBytes()));

			Cipher cipher = Cipher.getInstance("AES");
			cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(kgen.generateKey()
					.getEncoded(), "AES"));
			byte[] decryptBytes = cipher.doFinal(encryptBytes);

			return new String(decryptBytes);
		}

		private static String base64Encode(byte[] bytes) {
			return new BASE64Encoder().encode(bytes);
		}

		private static byte[] base64Decode(String base64Code) throws Exception {
			return base64Code.isEmpty() ? null : new BASE64Decoder()
					.decodeBuffer(base64Code);
		}
	}

