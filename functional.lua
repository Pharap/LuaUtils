-- Selects the first of n values
function first(a)
	return a
end

-- Selects the second of n values
function second(_, b)
	return b
end

-- Composes two functions
function compose(f, g)
	return function(...) return f(g(...)) end
end

-- Performs currying, i.e. binds arguments to a function
function curry(f, ...)
	local t = {...}
	return function(...)
		return f(table.unpack(t), ...)
	end
end

-- Transforms an iterated sequence
function map(func, iterator, state, var)	
	assert(type(func) == "function", "func must be a function")
	assert(type(iterator) == "function", "iterator must be a function")
	return function()
		local vars = { iterator(state, var) }
		var = vars[1]
		if var ~= nil then
			return func(table.unpack(vars))
		end
	end
end

-- Filters a sequence
function filter(predicate, iterator, state, var)	
	assert(type(predicate) == "function", "predicate must be a function")
	assert(type(iterator) == "function", "iterator must be a function")
	return function()
		while true do
			local vars = { iterator(state, var) }
			var = vars[1]
			if var == nil then
				break
			end
			if predicate(table.unpack(vars)) then
				return table.unpack(vars)
			end
		end
	end
end

-- Returns true if a predicate function is true for all values in a sequence
function all(predicate, iterator, state, var)
	assert(type(predicate) == "function", "predicate must be a function")
	assert(type(iterator) == "function", "iterator must be a function")
	while true do
		local vars = { iterator(state, var) }
		var = vars[1]
		if var == nil then
			return true
		end
		if not predicate(table.unpack(vars)) then
			return false
		end
	end
end

-- Returns true if a predicate function is true for any values in a sequence
function any(predicate, iterator, state, var)
	assert(type(predicate) == "function", "predicate must be a function")
	assert(type(iterator) == "function", "iterator must be a function")
	while true do
		local vars = { iterator(state, var) }
		var = vars[1]
		if var == nil then
			return false
		end
		if predicate(table.unpack(vars)) then
			return true
		end
	end
end

-- Counts the number of values in a sequence
function count(iterator, state, var)
	assert(type(iterator) == "function", "iterator must be a function")
	local i = 0
	while true do
		local var = iterator(state, var)
		if var ~= nil then
			i = i + 1
		end
	end
	return i
end

-- Performs a higher-order left fold on a sequence
function aggregate(seed, func, iterator, state, var)
	assert(type(func) == "function", "func must be a function")
	assert(type(iterator) == "function", "iterator must be a function")
	local accum = seed
	while true do
		local vars = { iterator(state, var) }
		var = vars[1]
		if var == nil then
			break
		end
		accum = func(accum, table.unpack(vars))
	end
	return accum
end
