extends GutTest

func test_eof():
	var match_eof: Callable = GAParse.eof()
	var success_result = match_eof.call("")
	var fail_result = match_eof.call("a")
	assert_true(success_result["success"], "Should match first when input is empty")
	assert_eq(success_result["result"], "", "Should return an empty string on a successful match")
	assert_eq(success_result["rest"], "", "Should return and empty string on a successful match")
	assert_false(fail_result["success"], "Should fail to match when string is not empty")

func test_char():
	var match_c: Callable = GAParse.char("c")
	var success_result = match_c.call("champion")
	var fail_result = match_c.call("apropos")
	assert_true(success_result["success"], "Should match first 'c' when input starts with 'c'")
	assert_eq(success_result["result"], "c", "Should return 'c' on a successful match")
	assert_eq(success_result["rest"], "hampion", "Should return the rest of the string on a successful match")
	assert_false(fail_result["success"], "Should fail to match 'c' when input does not start with 'c'")
	
func test_chars():
	var match_alpha: Callable = GAParse.chars("abcdefghijklmnopqrstuvwxyz".split(""))
	var success_result = match_alpha.call("champion")
	var fail_result = match_alpha.call("1a9e2b9c")
	assert_true(success_result["success"], "Should match first 'c' when input starts with 'c'")
	assert_eq(success_result["result"], "c", "Should return 'c' on a successful match")
	assert_eq(success_result["rest"], "hampion", "Should return the rest of the string on a successful match")
	assert_false(fail_result["success"], "Should fail to match any alphabetic characters when input does not start with letter")
	
func test_word():
	var match_person: Callable = GAParse.word("person")
	var success_result = match_person.call("personable")
	var fail_result = match_person.call("impersonal")
	assert_true(success_result["success"], "Should match first 'person' when input starts with 'person'")
	assert_eq(success_result["result"], "person", "Should return 'person' on a successful match")
	assert_eq(success_result["rest"], "able", "Should return the rest of the string on a successful match")
	assert_false(fail_result["success"], "Should fail to match 'person' when input does not start with 'person'")

func test_either():
	var match_a_or_b: Callable = GAParse.either([GAParse.char("a"), GAParse.char("b")])
	var success_result_one = match_a_or_b.call("axe")
	var success_result_two = match_a_or_b.call("back")
	var fail_result = match_a_or_b.call("cry")
	assert_true(success_result_one["success"], "Should match first 'a' when input starts with 'a'")
	assert_eq(success_result_one["result"], "a", "Should return 'a' on a successful match")
	assert_eq(success_result_one["rest"], "xe", "Should return the rest of the string on a successful match")
	assert_true(success_result_two["success"], "Should match first 'b' when input starts with 'b'")
	assert_eq(success_result_two["result"], "b", "Should return 'b' on a successful match")
	assert_eq(success_result_two["rest"], "ack", "Should return the rest of the string on a successful match")
	assert_false(fail_result["success"], "Should fail to match when input does not start with 'a' or 'b'")

func test_seq():
	var match_a_or_b: Callable = GAParse.either([GAParse.char("a"), GAParse.char("b")])
	var match_c_or_d: Callable = GAParse.either([GAParse.char("c"), GAParse.char("d")])
	var match_ab_cd_ab_cd: Callable = GAParse.seq([match_a_or_b, match_c_or_d, match_a_or_b, match_c_or_d])
	var success_result = match_ab_cd_ab_cd.call("adbc3")
	var fail_result = match_ab_cd_ab_cd.call("cabd")
	assert_true(success_result["success"], "Should match prefix when input starts with sequence")
	assert_eq(success_result["result"], "adbc", "Should return matched string on a successful match")
	assert_eq(success_result["rest"], "3", "Should return the rest of the string on a successful match")
	assert_false(fail_result["success"], "Should fail to match when input does not start with sequence")

func test_one_or_many():
	var match_many_a: Callable = GAParse.one_or_many(GAParse.char("a"))
	var success_result = match_many_a.call("aaaaaaabbbb")
	var fail_result = match_many_a.call("bbbbaaaaaaa")
	assert_true(success_result["success"], "Should match prefix when input starts with many a's")
	assert_eq(success_result["result"], "aaaaaaa", "Should return matched string on a successful match")
	assert_eq(success_result["rest"], "bbbb", "Should return the rest of the string on a successful match")
	assert_false(fail_result["success"], "Should fail to match when input does not start with many a's")

func test_many():
	var match_many_a: Callable = GAParse.many(GAParse.char("a"))
	var success_result_one = match_many_a.call("aaaaaaabbbb")
	var success_result_two = match_many_a.call("baaaaaaabbbb")
	assert_true(success_result_one["success"], "Should match prefix when input starts with many a's")
	assert_eq(success_result_one["result"], "aaaaaaa", "Should return matched string on a successful match")
	assert_eq(success_result_one["rest"], "bbbb", "Should return the rest of the string on a successful match")
	assert_true(success_result_two["success"], "Should match prefix when input starts with no a's")
	assert_eq(success_result_two["result"], "", "Should return matched string on a successful match")
	assert_eq(success_result_two["rest"], "baaaaaaabbbb", "Should return the rest of the string on a successful match")

func test_between():
	var match_parens: Callable = GAParse.between(GAParse.char("("),\
												GAParse.many(GAParse.char("a")),\
												GAParse.char(")"))
	var success_result = match_parens.call("(aaa)b")
	print(success_result)
	var fail_result_one = match_parens.call("aaab")
	var fail_result_two = match_parens.call("(aaab")
	print(fail_result_two)
	assert_true(success_result["success"], "Should match contents between parens when parens prefix string")
	assert_eq(success_result["result"], "aaa", "Should return the contents between parens")
	assert_eq(success_result["rest"], "b", "Should return the rest of the string on a successful match")
	assert_false(fail_result_one["success"], "Should fail to match when input is not prefixed by parens")
	assert_false(fail_result_two["success"], "Should fail to match when input is not prefixed by matching parens")
