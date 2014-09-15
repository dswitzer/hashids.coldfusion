component extends="mxunit.framework.TestCase" output="false" persistent="false" {
	/**
	* These tests are from:
	* https://github.com/jiecao-fm/hashids-java/blob/master/src/test/java/fm/jiecao/lib/HashidsTest.java
	*/
	public void function test_one_number(){
		var input = [12345];
		var salt = "this is my salt";
		var expected = "NkK9";

		var hasher = new com.utils.Hashids(salt);
		var results = hasher.encode(input);

		// make sure the string encodes as expected
		assertEquals(expected, results);
		// make sure the string decodes back to the original value
		assertEquals(input, hasher.decode(results));
	}

	public void function test_several_numbers(){
		var input = [683, 94108, 123, 5];
		var salt = "this is my salt";
		var expected = "aBMswoO2UB3Sj";

		var hasher = new com.utils.Hashids(salt);
		var results = hasher.encode(input);

		// make sure the string encodes as expected
		assertEquals(expected, results);
		// make sure the string decodes back to the original value
		assertEquals(input, hasher.decode(results));
	}

	public void function test_specifying_custom_hash_length(){
		var input = [1];
		var salt = "this is my salt";
		var expected = "gB0NV05e";

		var hasher = new com.utils.Hashids(salt, 8);
		var results = hasher.encode(input);

		// make sure the string encodes as expected
		assertEquals(expected, results);
		// make sure the string decodes back to the original value
		assertEquals(input, hasher.decode(results));
	}

	public void function test_specifying_custom_hash_alphabet(){
		var input = [1234567];
		var salt = "this is my salt";
		var expected = "bbdd589a";

		var hasher = new com.utils.Hashids(salt=salt, alphabet="0123456789abcdef");
		var results = hasher.encode(input);

		// make sure the string encodes as expected
		assertEquals(expected, results);
		// make sure the string decodes back to the original value
		assertEquals(input, hasher.decode(results));
	}

	public void function test_randomness(){
		var input = [5, 5, 5, 5];
		var salt = "this is my salt";
		var expected = "1Wc8cwcE";

		var hasher = new com.utils.Hashids(salt=salt);
		var results = hasher.encode(input);

		// make sure the string encodes as expected
		assertEquals(expected, results);
		// make sure the string decodes back to the original value
		assertEquals(input, hasher.decode(results));
	}

	public void function test_randomness_for_incrementing_numbers(){
		var input = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		var salt = "this is my salt";
		var expected = "kRHnurhptKcjIDTWC3sx";

		var hasher = new com.utils.Hashids(salt=salt);
		var results = hasher.encode(input);

		// make sure the string encodes as expected
		assertEquals(expected, results);
		// make sure the string decodes back to the original value
		assertEquals(input, hasher.decode(results));
	}

	public void function test_randomness_for_incrementing(){
		var salt = "this is my salt";

		var hasher = new com.utils.Hashids(salt=salt);

		// test the input for randomness
		assertEquals(hasher.encode(1), "NV");
		assertEquals(hasher.encode(2), "6m");
		assertEquals(hasher.encode(3), "yD");
		assertEquals(hasher.encode(4), "2l");
		assertEquals(hasher.encode(5), "rD");
	}

	public void function test_for_values_greater_int_maxval(){
		var salt = "this is my salt";

		var hasher = new com.utils.Hashids(salt=salt);

		// test the input for randomness
		assertEquals(hasher.encode(9876543210123), "Y8r7W1kNN");
	}


}