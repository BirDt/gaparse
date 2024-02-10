extends GutTest

func test_atext():
	var success_one = EmailParser.atext("BirDt_&y91")
	var failure_one = EmailParser.atext("")
	var failure_two = EmailParser.atext("[thisfails]")
	assert_true(success_one["success"], "Should match valid atext string")
	assert_eq(success_one["result"], "BirDt_&y91", "Should return matched string")
	assert_eq(success_one["rest"], "", "Should consume full string")
	assert_false(failure_one["success"], "Should fail to match empty string")
	assert_false(failure_two["success"], "Should fail to match invalid atext string")

func test_ldh_str():
	var success_one = EmailParser.ldh_str("a1-B0")
	var failure_one = EmailParser.ldh_str("")
	var failure_two = EmailParser.ldh_str("*&%^noSpecialChars")
	print(failure_two)
	assert_true(success_one["success"], "Should match valid ldh string")
	assert_eq(success_one["result"], "a1-B0", "Should return matched string")
	assert_eq(success_one["rest"], "", "Should consume full string")
	assert_false(failure_one["success"], "Should fail to match empty string")
	assert_false(failure_two["success"], "Should fail to match invalid ldh string")

func test_email_parser():
	var success_one = EmailParser.parse_email_address("birdt_@cyan.sh")
	var success_two = EmailParser.parse_email_address("1^sdb@w10-a.k.1-2a.-; everything here is returned")
	var failure_one = EmailParser.parse_email_address("")
	var failure_two = EmailParser.parse_email_address("@ex.net")
	assert_true(success_one["success"], "Should match valid email address")
	assert_eq(success_one["result"], "birdt_@cyan.sh", "Should return matched string")
	assert_eq(success_one["rest"], "", "Should consume full string")
	assert_true(success_two["success"], "Should match valid email address if string starts with valid address")
	assert_eq(success_two["result"], "1^sdb@w10-a.k.1-2a.-", "Should return matched string")
	assert_eq(success_two["rest"], "; everything here is returned", "Should return remainder of input")
	assert_false(failure_one["success"], "Should fail to match empty string")
	assert_false(failure_two["success"], "Should fail to match invalid email address")
