component extends="mxunit.framework.TestCase" output="false" persistent="false" {
	/**
	* unit tests
	*/

	// ENCRYPT TESTS
	public void function js_compatibility_encrypt_single(){
		var expected = "j0gW";
		var hashids = new com.utils.Hashids();
		var numbers = 12345;

		var actual = hashids.encrypt(numbers);
		assertEquals(expected, actual);
	}

	public void function js_compatibility_encrypt_single_with_salt(){
		var expected = "NkK9";
		var hashids = new com.utils.Hashids("this is my salt");
		var numbers = 12345;

		var actual = hashids.encrypt(numbers);
		assertEquals(expected, actual);
	}

	public void function js_compatibility_encrypt_multiple(){
		var expected = "o2fXhV";
		var hashids = new com.utils.Hashids();

		var actual = hashids.encrypt(1, 2, 3);
		assertEquals(expected, actual);
	}

	public void function js_compatibility_encrypt_multiple_as_array(){
		var expected = "o2fXhV";
		var hashids = new com.utils.Hashids();
		var numbers = [1, 2, 3];

		var actual = hashids.encrypt(numbers);
		assertEquals(expected, actual);
	}

	public void function js_compatibility_encrypt_multiple_with_salt(){
		var expected = "laHquq";
		var hashids = new com.utils.Hashids("this is my salt");
		var numbers = [1, 2, 3];

		var actual = hashids.encrypt(numbers);
		assertEquals(expected, actual);
	}


	// DECRYPT TESTS
	public void function js_compatibility_decrypt_single(){
		var expected = [12345];
		var hash = "j0gW";
		var hashids = new com.utils.Hashids();

		var actual = hashids.decrypt(hash);
		assertEquals(expected, actual);
	}

	public void function js_compatibility_decrypt_single_with_salt(){
		var expected = [12345];
		var hash = "NkK9";
		var hashids = new com.utils.Hashids("this is my salt");

		var actual = hashids.decrypt(hash);
		assertEquals(expected, actual);
	}

	public void function js_compatibility_decrypt_multiple(){
		var expected = [1, 2, 3];
		var hash = "o2fXhV";
		var hashids = new com.utils.Hashids();

		var actual = hashids.decrypt(hash);
		assertEquals(expected, actual);
	}

	public void function js_compatibility_decrypt_multiple_as_array(){
		var expected = [1, 2, 3];
		var hash = "o2fXhV";
		var hashids = new com.utils.Hashids();

		var actual = hashids.decrypt(hash);
		assertEquals(expected, actual);
	}

	public void function js_compatibility_decrypt_multiple_with_salt(){
		var expected = [1, 2, 3];
		var hash = "laHquq";
		var hashids = new com.utils.Hashids("this is my salt");

		var actual = hashids.decrypt(hash);
		assertEquals(expected, actual);
	}

	// MISCELLANEOUS TESTS
	public void function js_compatibility_consistentShuffle(){
		var expected = "UHuhtcITCsFifS";
		var hashids = new com.utils.Hashids("this is my salt");

		// make the method we're testing public
		makePublic(hashids, "consistentShuffle");

		var actual = hashids.consistentShuffle("cfhistuCFHISTU", hashids.getSalt());
		assertEquals(expected, actual);
	}

}