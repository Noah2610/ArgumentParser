#!/bin/env ruby

def get_options valid_args = {}
	return nil  if (valid_args.nil? || valid_args.empty?)

	ret = {
		opts:     {},
		keywords: {}
	}

	set_opt_val_of = nil
	set_kw_val_of = nil
	cur_kw_chain = nil
	## Loop through all command-line arguments
	ARGV.each do |argument|

		## Check valid SINGLE options
		if (argument =~ /\A-[\w\d]+\z/)
			## Get all options of argument
			cur_opts = argument.delete("-").split("")
			valid_args[:single].each do |id, val|
				## Loop through every command-line option of current argument
				#  ex.: -abc -> a,b,c
				cur_opts.each do |opt|
					if (val.first.include? opt)
						## Check if option takes value
						if (val.last)
							ret[:opts][id] = nil
							set_opt_val_of = id
						else
							ret[:opts][id] = true
						end
					end
				end
			end

		## Check valid DOUBLE options
		elsif (argument =~ /\A--[\w\d]+\z/)
			cur_opt = argument.delete("--")
			valid_args[:double].each do |id, val|
				if (val.first.include? cur_opt)
					## Check if option takes value
					if (val.last)
						ret[:opts][id] = nil
						set_opt_val_of = id
					else
						ret[:opts][id] = true
					end
				end
			end

		## Check valid KEYWORDS or values
		elsif !(argument =~ /\A-{1,2}/)
			## Set value of previously found option
			if (set_opt_val_of)
				ret[:opts][set_opt_val_of] = argument
				set_opt_val_of = nil
				next
			elsif (set_kw_val_of)
				ret[:keywords][set_kw_val_of] << argument
				set_kw_val_of = nil
				next
			end

			## Check if in kw-chain or for valid keyword
			if (cur_kw_chain.nil?)
				valid_args[:keywords].each do |id, val|
					if (val.first.include? argument)
						ret[:keywords][id] = [argument]
						cur_kw_chain = id
						break
					end
				end
			else
				## Check if argument is valid for next kw in kw-chain
				kw_chain_index = ret[:keywords][cur_kw_chain].size
				next  if (kw_chain_index >= valid_args[:keywords][cur_kw_chain].size)
				unless (valid_args[:keywords][cur_kw_chain][kw_chain_index] == :INPUT)
					if (valid_args[:keywords][cur_kw_chain][kw_chain_index].include? argument)
						ret[:keywords][cur_kw_chain] << argument
					end

				else
					## Custom user input
					ret[:keywords][cur_kw_chain] << argument
				end
			end
		end

	end

	return ret
end

