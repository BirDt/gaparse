extends Object
class_name GAParse

static func eof() -> Callable:
	return func(input: String) -> Dictionary:
		if input == "":
			return {success=true, result="", rest=""}
		else:
			return {success=false}

static func char(mchar: String) -> Callable:
	assert(len(mchar) == 1, "char parser must take a string argument of exactly length 1")
	return func(input: String) -> Dictionary:
		if input[0] == mchar:
			return {success=true, result=mchar, rest=input.substr(1)}
		else:
			return {success=false}

static func chars(mchars: Array[String]) -> Callable:
	var char_matchers: Array[Callable] = []
	for c in mchars:
		char_matchers.push_back(GAParse.char(c))
	return any(char_matchers)

static func word(mword: String) -> Callable:
	return func(input: String) -> Dictionary:
		if input.begins_with(mword):
			return {success=true, result=mword, rest=input.substr(len(mword))}
		else:
			return {success=false}

static func any(parsers: Array[Callable]) -> Callable:
	return func(input: String) -> Dictionary:
		for p in parsers:
			var res = p.call(input)
			if res["success"]:
				return res
		return {success=false}

static func seq(parsers: Array[Callable]) -> Callable:
	return func(input: String) -> Dictionary:
		var result = ""
		var rest = input
		for p in parsers:
			var res = p.call(rest)
			if res["success"]:
				rest = res["rest"]
				result += res["result"]
			else:
				return {success=false}
		return {success=true, result=result, rest=rest}

static func one_or_many(parser: Callable) -> Callable:
	return func(input: String) -> Dictionary:
		var result = ""
		var rest = input
		var res = parser.call(rest)
		if not res["success"]:
			return {success=false}
		rest = res["rest"]
		result += res["result"]
		for c in rest:
			res = parser.call(rest)
			if res["success"]:
				rest = res["rest"]
				result += res["result"]
			else:
				break
		return {success=true, result=result, rest=rest}

static func many(parser: Callable) -> Callable:
	return func(input: String) -> Dictionary:
		var result = ""
		var rest = input
		for c in rest:
			var res = parser.call(rest)
			if res["success"]:
				rest = res["rest"]
				result += res["result"]
			else:
				break
		return {success=true, result=result, rest=rest}

static func between(open: Callable, parser: Callable, close: Callable) -> Callable:
	return func(input: String) -> Dictionary:
		var open_res = open.call(input)
		if not open_res["success"]:
			return {success=false}
		var res = parser.call(open_res["rest"])
		if not res["success"]:
			return {success=false}
		var close_res = close.call(res["rest"])
		if not close_res["success"]:
			return {success=false}
		return {success=true, result=res["result"], rest=close_res["rest"]}
