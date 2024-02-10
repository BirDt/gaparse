extends Object
class_name EmailParser

## References: 
## https://www.rfc-editor.org/rfc/rfc5322
## https://www.rfc-editor.org/rfc/rfc1034

# Any alphabet character
static var alpha = GAParse.chars("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split(""))
# Any digit
static var digit = GAParse.chars("0123456789".split(""))
static var additional_atext_chars = GAParse.chars("!#$%&’*+-/=?^_‘{|}~".split(""))
# From RFC5322:
# atext = ALPHA / DIGIT / "!" / "#" / "$" / "%" / "&" / "'" / "*" /
#			"+" / "-" / "/" / "=" / "?" / "^" / "_" / "`" / "{" /
#			"|" / "}" / "~"
static var atext_parser = GAParse.one_or_many(GAParse.any([alpha, digit, additional_atext_chars]))
# From RFC1034
# let-dig = letter / digit
# let-dig-hyp = let-dig / "-"
# ldh-str = let-dig-hyp / let-dig-hyp ldh-str
static var let_dig_hyp = GAParse.any([alpha, digit, GAParse.char("-")])
static var ldh_str_parser = GAParse.one_or_many(let_dig_hyp)

# Shortcut to call the atext parser
static func atext(input: String):
	return atext_parser.call(input)

# Shortcut to call the ldh-str parser
static func ldh_str(input: String):
	return ldh_str_parser.call(input)

# Matches the first valid email address substring
static func parse_email_address(input: String):
	var email_parser = GAParse.seq([atext_parser,\
									GAParse.char("@"),\
									ldh_str_parser,\
									GAParse.one_or_many(GAParse.seq([GAParse.char("."),\
																	ldh_str_parser]))])
	return email_parser.call(input)

# Matches only if the entire input string is a valid email address
static func parse_email_address_with_eof(input: String):
	var email_parser = GAParse.seq([atext_parser,\
									GAParse.char("@"),\
									ldh_str_parser,\
									GAParse.one_or_many(GAParse.seq([GAParse.char("."),\
																	ldh_str_parser])),\
									GAParse.eof()])
	return email_parser.call(input)
