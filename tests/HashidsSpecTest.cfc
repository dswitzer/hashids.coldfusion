component extends="mxunit.framework.TestCase" output="false" persistent="false" {
	/**
	* These tests are from:
	* https://github.com/ivanakimov/hashids.node.js/blob/master/spec/hashids.spec.js
	*/

	public void function should_pass_basic_encryption(){
		var hashids = new com.utils.Hashids();
		var numbers = [1, 2, 3, 4, 5];

		var hash = hashids.encrypt(numbers);
		var returnedNumbers = hashids.decrypt(hash);

		// expect the hash to have some length
		assertTrue(len(hash));
		// expect the input to match the decrypted value
		assertEquals(numbers, returnedNumbers);
	}

	public void function should_pass_encryption_by_passing_a_hex_string_mongodb_test(){
		var hashids = new com.utils.Hashids();
		var hex = "507f1f77bcf86cd799439011";

		var hash = hashids.encryptHex(hex);
		var returnedHex = hashids.decryptHex(hash);

		// expect the hash to have some length
		assertTrue(len(hash));
		// expect the input to match the decrypted value
		assertEquals(hex, returnedHex);
	}

	public void function should_pass_encryption_by_passing_a_hex_string_mongodb_test_with_minimum_hash_length_parameter(){
		var minHashLength = 1000;
		var hashids = new com.utils.Hashids("", minHashLength);
		var hex = "507f1f77bcf86cd799439011";

		var hash = hashids.encryptHex(hex);
		var returnedHex = hashids.decryptHex(hash);

		// expect the hash to have some length
		assertTrue(len(hash));
		// expect the input to match the decrypted value
		assertEquals(hex, returnedHex);
		// expect the hash length to equal the minimum length
		assertEquals(len(hash), minHashLength);
	}

	public void function should_pass_encryption_by_passing_a_long_hex_string_mongodb_test(){
		var hashids = new com.utils.Hashids();
		var hex = "f000000000000000000000000000000000000000000000000000000000000000000000000000000000000f";

		var hash = hashids.encryptHex(hex);
		var returnedHex = hashids.decryptHex(hash);

		// expect the hash to have some length
		assertTrue(len(hash));
		// expect the input to match the decrypted value
		assertEquals(hex, returnedHex);
	}

	public void function should_pass_basic_encryption_with_salt_value(){
		var hashids = new com.utils.Hashids("this is my salt");
		var numbers = [1, 2, 3, 4, 5];

		var hash = hashids.encrypt(numbers);
		var returnedNumbers = hashids.decrypt(hash);

		// expect the hash to have some length
		assertTrue(len(hash));
		// expect the input to match the decrypted value
		assertEquals(numbers, returnedNumbers);
		// make sure not equal to default salt
		assertNotEquals(hash, new com.utils.Hashids().encrypt(numbers));
	}

	public void function should_pass_encryption_with_salt_value_and_minimum_hash_length(){
		var minHashLength = 1000;
		var hashids = new com.utils.Hashids("this is my salt", minHashLength);
		var numbers = [1, 2, 3, 4, 5];

		var hash = hashids.encrypt(numbers);
		var returnedNumbers = hashids.decrypt(hash);

		// expect the hash to have some length
		assertTrue(len(hash));
		// expect the input to match the decrypted value
		assertEquals(numbers, returnedNumbers);
		// expect the hash length to equal the minimum length
		assertEquals(len(hash), minHashLength);
	}

	public void function should_pass_encryption_with_salt_value_and_big_minimum_hash_length(){
		var minHashLength = 10000; // spec calls for 1m, but unpractical number and very slow
		var hashids = new com.utils.Hashids("this is my salt", minHashLength);
		var numbers = [1, 2, 3, 4, 5];

		var hash = hashids.encrypt(numbers);
		var returnedNumbers = hashids.decrypt(hash);

		// expect the hash to have some length
		assertTrue(len(hash));
		// expect the input to match the decrypted value
		assertEquals(numbers, returnedNumbers);
		// expect the hash length to equal the minimum length
		assertEquals(len(hash), minHashLength);
	}

	public void function should_pass_encryption_with_salt_value_minimum_hash_length_and_custom_alphabet(){
		var minHashLength = 1000;
		var customAlphabet = "0123456789abcdef";
		var hashids = new com.utils.Hashids("this is my salt", minHashLength, customAlphabet);
		var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

		var hash = hashids.encrypt(numbers);
		var returnedNumbers = hashids.decrypt(hash);

		// expect the hash to have some length
		assertTrue(len(hash));
		// expect the input to match the decrypted value
		assertEquals(numbers, returnedNumbers);
		// expect the hash length to equal the minimum length
		assertEquals(len(hash), minHashLength);
		// expect the results to appear to be in a hex format
		assertTrue(reFindNoCase("^[0-9a-f]+$", hash));
	}

}