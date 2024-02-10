extends Object
class_name EmailParser

## References: 
## https://www.rfc-editor.org/rfc/rfc5322
## https://www.rfc-editor.org/rfc/rfc1034

static var alpha = GAParse.chars("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split(""))
static var digit = GAParse.chars("0123456789".split(""))
static var additional_atext_chars = GAParse.chars("!#$%&’*+-/=?^_‘{|}~".split(""))
static var atext_parser = GAParse.one_or_many(GAParse.any([alpha, digit, additional_atext_chars]))
static var dig_hyp = GAParse.any([alpha, digit, GAParse.char("-")])
static var ldh_str_parser = GAParse.one_or_many(dig_hyp)

static func atext(input: String):
	return atext_parser.call(input)

static func ldh_str(input: String):
	return ldh_str_parser.call(input)

static func parse_email_address(input: String):
	var email_parser = GAParse.seq([atext_parser,\
									GAParse.char("@"),\
									ldh_str_parser,\
									GAParse.one_or_many(GAParse.seq([GAParse.char("."),\
																	ldh_str_parser]))])
	return email_parser.call(input)
