/*
	hashids
	https://github.com/dswitzer/hashids.coldfusion
	(c) 2014 Dan G. Switzer, II

	hashids may be freely distributed under the MIT license.

	This is a ColdFusion port of the http://www.hashids.org/ library.
*/
component output="false" persistent="false" {
	/**
	* PRIVATE VARIABLES
	*/
	variables.instance = {
		// internal settings (GETTERS only)
		  version= "1.0.0"
		, minAlphabetLength = 16
		, seps= "cfhistuCFHISTU"
		, guards= ""
		, sepDiv = 3.5
		, guardDiv = 12

		// configurable settings(GETTERS & SETTERS)
		, salt= ""
		, minLen= 0
		, alphabet= "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	};

	/**
	* INITIALIZATION
	*/
	public any function init(string salt, numeric minLen, string alphabet) output="false" {
		if( structKeyExists(arguments, "salt") ){
			setSalt(arguments.salt);
		}

		if( structKeyExists(arguments, "minLen") ){
			setMinLen(arguments.minLen);
		}

		if( structKeyExists(arguments, "alphabet") ){
			setAlphabet(arguments.alphabet);
		} else {
			prepareEngine();
		}

		return this;
	}

	/**
	* SETTERS/GETTERS
	*/
	public string function getVersion() output="false" {
		return variables.instance.version;
	}

	public string function getMinAlphabetLength() output="false" {
		return variables.instance.minAlphabetLength;
	}

	public string function getSeps() output="false" {
		return variables.instance.seps;
	}

	public numeric function getSepDiv() output="false" {
		return variables.instance.sepDiv;
	}

	public string function getGuards() output="false" {
		return variables.instance.guards;
	}

	public numeric function getGuardDiv() output="false" {
		return variables.instance.guardDiv;
	}


	public string function getSalt() output="false" {
		return variables.instance.salt;
	}

	public void function setSalt(required string salt) output="false" {
		variables.instance.salt = arguments.salt;
	}

	public string function getMinLen() output="false" {
		return variables.instance.minLen;
	}

	public void function setMinLen(required string minLen) output="false" {
		variables.instance.minLen = arguments.minLen;
	}

	public string function getAlphabet() output="false" {
		return variables.instance.alphabet;
	}

	public void function setAlphabet(required string alphabet) output="false" {
		// make alphabet unique
		var uniqueAlphabet = "";
		var alphaLen = len(arguments.alphabet);
		var currentChar = "";

		for( var i=1; i <= alphaLen; i++ ){
			currentChar = mid(arguments.alphabet, i, 1);
			if( !find(currentChar, uniqueAlphabet) ){
				uniqueAlphabet &= currentChar;
			}
		}

		// validate input
		if( len(uniqueAlphabet) < getMinAlphabetLength() ){
			throw "error: alphabet must contain at least #getMinAlphabetLength()# unique characters";
		}

		if( reFind("\s", uniqueAlphabet) ){
			throw "error: alphabet cannot contain spaces";
		}

		// set the alphabet
		variables.instance.alphabet = uniqueAlphabet;

		// prepare the alphabet
		prepareEngine();
	}


	/**
	* PRIVAYE METHODS
	*/
	private void function prepareEngine() output="false" {
		/* seps should contain only characters present in alphabet; alphabet should not contains seps */
		var alphabet = variables.instance.alphabet;
		var seps = variables.instance.seps;
		var guards = "";

		var sepsLen = len(seps);
		var j = 0;
		var currentChar = "";

		for( var i=1; i <= sepsLen; i++ ){
			currentChar = mid(seps, i, 1);
			j = find(currentChar, alphabet);
			if( j == 0 ){
				seps = seps.substring(0, i-1) & " " & seps.substring(i);
			} else {
				alphabet = alphabet.substring(0, j-1) & " " & alphabet.substring(j);
			}
		}

		// remove spaces
		alphabet = alphabet.replaceAll(" ", "");
		seps = seps.replaceAll(" ", "");

		// make a consistent shuffle for the values
		seps = consistentShuffle(seps, getSalt());

		sepsLen = len(seps);
		var alphabetLen = len(alphabet);
		var sepDiff = alphabetLen / sepsLen;

		if( !len(seps) || (sepDiff > getSepDiv()) ){
			sepsLen = ceiling(alphabetLen / getSepDiv());
			if( sepsLen == 1 ){
				sepsLen++;
			}

			// make the separator meet the min guard length, by moving items from the alphabet to the separator
			if( sepsLen > len(seps) ){
				var diff = sepsLen - len(seps);
				seps &= alphabet.substring(0, diff);
				alphabet = alphabet.substring(diff);
			} else {
				seps = seps.substring(0, sepsLen);
			}

		}

		// make a consistent shuffle for the values
		alphabet = consistentShuffle(alphabet, getSalt());
		alphabetLen = len(alphabet);

		// create the guard rules
		var guardCount = ceiling(alphabetLen / getGuardDiv());

		if( alphabetLen < 3 ){
			guards = seps.substring(0, guardCount);
			seps = seps.substring(guardCount);
		} else {
			guards = alphabet.substring(0, guardCount);
			alphabet = alphabet.substring(guardCount);
		}

		variables.instance.alphabet = alphabet;
		variables.instance.seps = seps;
		variables.instance.guards = guards;
	}

	private function consistentShuffle(required string alphabet, required string salt) output="false" {
		var saltLen = len(arguments.salt);

		if( !saltLen ){
			return arguments.alphabet;
		}

		var i = 0;
		var j = 0;
		var v = 0;
		var p = 0;
		var integer = 0;
		var temp = "";

		for( i=len(arguments.alphabet) - 1; i > 0; i-- ){
			v %= saltLen;
			integer = asc(mid(arguments.salt, v+1, 1));
			p += integer;
			j = (integer + v + p) % i;

			temp = mid(arguments.alphabet, j+1, 1);
			arguments.alphabet = arguments.alphabet.substring(0, j) & mid(arguments.alphabet, i+1, 1) & arguments.alphabet.substring(j + 1);
			arguments.alphabet = arguments.alphabet.substring(0, i) & temp & arguments.alphabet.substring(i + 1);

			v++;
		}

		return arguments.alphabet;
	}

	private any function preciseMod(required input, required modulus) output="false" {
		return createObject("java", "java.math.BigInteger").init(javaCast("long", arguments.input).toString()).remainder(createObject("java", "java.math.BigInteger").init(javaCast("long", arguments.modulus).toString())).longValue();
	}

	private string function encoder(required array numbers) output="false" {
		var results = "";
		var lottery = "";
		var i = 0;
		var number = 0;
		var buffer = "";
		var last = "";
		var sepsIndex = 0;
		var guardIndex = 0;
		var guard = "";
		var halfLength = 0;
		var excess = "";
		var alphabet = getAlphabet();
		var numbersSize = arrayLen(arguments.numbers);
		var numbersHashInt = 0;
		var len = numbersSize;
		var minHashLen = getMinLen();
		var guards = getGuards();
		var startPos = 0;

		for( i=0; i < len; i++ ){
//			numbersHashInt += (numbers[i+1] % (i + 100));
			numbersHashInt += preciseMod(arguments.numbers[i+1], (i + 100));
		}

		results = mid(alphabet, (numbersHashInt % len(alphabet))+1, 1);
		lottery = results;

		for( i=0; i < len; i++){
			number = arguments.numbers[i+1];
			buffer = lottery & getSalt() & alphabet;

			alphabet = consistentShuffle(alphabet, buffer.substring(0, len(alphabet)));
			last = this.hash(number, alphabet);

			results &= last;

			if( i+1 < numbersSize ){
//				number %= (asc(last) + i);
				number = preciseMod(number, (asc(last) + i));
				sepsIndex = number % len(getSeps());
				results &= mid(getSeps(), sepsIndex+1, 1);
			}

		}

		if( len(results) < minHashLen ){
			guardIndex = (numbersHashInt + asc(mid(results, 1, 1))) % len(guards);
			guard = mid(guards, guardIndex+1, 1);

			results = guard & results;

			if( len(results) < minHashLen ){
				guardIndex = (numbersHashInt + asc(mid(results, 3, 1))) % len(guards);
				guard = mid(guards, guardIndex+1, 1);
				results &= guard;
			}
		}

		halfLength = int(len(alphabet) / 2);

		while( len(results) < minHashLen ){

			alphabet = consistentShuffle(alphabet, alphabet);
			results = alphabet.substring(halfLength) & results & alphabet.substring(0, halfLength);

			excess = len(results) - minHashLen;

			if( excess > 0 ){
				startPos = excess / 2;
				results = results.substring(startPos, startPos + minHashLen);
			}
		}

		return results;
	}

	private function decoder(required string hash, required string alphabet) output="false" {
		var results = [];
		var i = 0;
		var lottery = "";
		var len = "";
		var subHash = "";
		var buffer = "";
		var regexp = "[" & getGuards() & "]";
		var hashBreakdown = arguments.hash.replaceAll(regexp, " ");
		var hashArray = hashBreakdown.split(" ");
		var hashArrayLen = arrayLen(hashArray);

		if( hashArrayLen == 3 || hashArrayLen == 2) {
			i = 1;
		}

		hashBreakdown = hashArray[i+1];
		if( len(hashBreakdown) ){
			lottery = mid(hashBreakdown, 1, 1);
			hashBreakdown = hashBreakdown.substring(1);
			hashBreakdown = hashBreakdown.replaceAll("[" & getSeps() & "]", " ");
			hashArray = hashBreakdown.split(" ");

			len = arrayLen(hashArray);

			for( i=0; i != len; i++ ){
				subHash = hashArray[i+1];
				buffer = lottery & getSalt() & arguments.alphabet;
				arguments.alphabet = consistentShuffle(arguments.alphabet, buffer.substring(0, len(arguments.alphabet)));
				arrayAppend(results, this.unhash(subHash, arguments.alphabet));
			}

			if( this.encode(results) != arguments.hash ){
				results = [];
			}

		}

		return results;
	}



	/**
	* PUBLIC METHODS
	*/
	public string function encode() output="false" {
		var results = "";
		var argsLen = arrayLen(arguments);
		var numbers = [];
		var numberLen = 0;

		// if nothing passed in
		if( argsLen eq 0 ){
			return results;
		}

		// convert the arguments into an array
		for( var i=1; i <= argsLen; i++ ){
			arrayAppend(numbers, arguments[i]);
			numberLen++;
		}

		// if the first value in arguments, was actually an array, use that instead
		if( isArray(numbers[1]) ){
			numbers = numbers[1];
			numberLen = arrayLen(numbers);
		}


		// make sure all the inputs are positive integers
		for( var i=1; i <= numberLen; i++ ){
			try {
				// try to convert input into a long
				numbers[i] = javaCast("long", numbers[i]);
			} catch (Any e){
				return results;
			}

			if( numbers[i] < 0 ){
				return results;
			}
		}


		return encoder(numbers);
	}

	public array function decode(required string hash) output="false" {
		var results = [];

		if( !len(arguments.hash) || !isSimpleValue(arguments.hash) ){
			return results;
		}

		return decoder(arguments.hash, getAlphabet());
	}

	public function encodeHex(required string input) output="false" {
		var i = 0;
		var len = 0;
		var numbers = 0;
		var numbersLen = 0;

		if( !reFindNoCase("^[0-9a-f]+$", arguments.input) ){
			return "";
		}

		numbers = reMatch("[\w\W]{1,12}", arguments.input);
		numbersLen = arrayLen(numbers);

		for( i=1; i <= numbersLen; i++ ){
			numbers[i] = createObject("java", "java.lang.Long").parseLong(javaCast("string", "1" & numbers[i]), javaCast("int", 16));
		}

		return this.encode(numbers);
	}

	public function decodeHex(required string hash) output="false" {
		var results = "";
		var i = 0;
		var len = 0;
		var numbers = this.decode(arguments.hash);
		var numbersLen = arrayLen(numbers);

		for( i=1; i <= numbersLen; i++){
			results &= createObject("java", "java.math.BigInteger").init(javaCast("string", numbers[i])).toString(16).substring(1);
		}

		return results;
	}

	public function hash(required numeric input, required string alphabet) output="false" {

		var hash = "";
		var alphabetLength = len(arguments.alphabet);

		do {
//			hash = mid(arguments.alphabet, (arguments.input % alphabetLength)+1, 1) & hash;
			hash = mid(arguments.alphabet, preciseMod(arguments.input, alphabetLength)+1, 1) & hash;
			arguments.input = int(arguments.input / alphabetLength);
		} while( arguments.input > 0 );

		return hash;
	}

	public function unhash(required string input, required string alphabet) output="false" {
		var number = 0;
		var pos = 0;
		var i = 0;

		for( i=0; i < len(arguments.input); i++ ){
			pos = find(mid(arguments.input, i+1, 1), arguments.alphabet)-1;
			number += pos * (len(arguments.alphabet) ^ (len(arguments.input) - i - 1));
		}

		return javaCast("long", number);
	}

}