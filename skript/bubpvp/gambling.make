command /gamble [<text>]:
	trigger:
		if arg-1 is not set:
			play sound "entity.chicken.egg" to player
			open virtual chest inventory with size 3 named "&3&lGAMBLE YO MONEY" to player
			format gui slot 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, and 26 of player with light gray stained glass pane named "&1"
			format gui slot 10 of player with emerald named "&3Coinflip" to run:
				coinflip(player)
			format gui slot 13 of player with white concrete named "&3Clicker" to run:
				clicker(player)
			format gui slot 16 of player with barrier named "&4&lCOMING SOON"
		else if arg-1 is "stat" or "stats":
			play sound "entity.chicken.egg" to player
			open virtual chest inventory with size 3 named "&3&lGAMBLE STATS" to player
			format gui slot 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, and 26 of player with light gray stained glass pane named "&1"
			format gui slot 10 of player with emerald named "&3Coinflip" to close:
				play sound "entity.chicken.egg" to player
				send "" to player
				send "&3&lCOINFLIP STATS" to player
				send "" to player
				send "&3Wins: &f%{cfwin::%player's uuid%}%" to player
				send "&3Losses: &f%{cfloss::%player's uuid%}%" to player
				send "&3Profit: &f$%{cfprofit::%player's uuid%}%" to player
				send "" to player
			format gui slot 13 of player with white concrete named "&3Clicker" to close:
				play sound "entity.chicken.egg" to player
				send "" to player
				send "&3&lCLICKER STATS" to player
				send "" to player
				send "&3Wins: &f%{clwin::%player's uuid%}%" to player
				send "&3Losses: &f%{clloss::%player's uuid%}%" to player
				send "&3Profit: &f$%{clprofit::%player's uuid%}%" to player
				send "" to player
			format gui slot 16 of player with barrier named "&4&lCOMING SOON"

command /cf [<text>]:
	aliases: coinflip
	trigger:
		if arg-1 parsed as a number is an integer:
			if {cf::%player's uuid%} is not set:
				set {_aa} to arg-1 parsed as a number
				if {_aa} is greater than or equal to 100:
					if {_aa} is less than or equal to {balance::%player's uuid%}:
						set {cf::%player's uuid%} to {_aa}
						subtract {_aa} from {balance::%player's uuid%}
						send "&3&lBubPVP: &fYou have made a coinflip for &3$%{_aa}%&3!"
						loop all players:
							if name of loop-player's current inventory is "&3Coinflips":
								coinflip(loop-player)
					else:
						send "&4ERROR: &cYou don't have enough money to do this!"
				else:
					send "&4ERROR: &cThe minimum amount for a coinflip is &3$100!"
			else:
				send "&4ERROR: &cYou already have an existing coinflip!"
		else if arg-1 is "stat" or "stats":
			play sound "entity.chicken.egg" to player
			send "" to player
			send "&3&lCOINFLIP STATS" to player
			send "" to player
			send "&3Wins: &f%{cfwin::%player's uuid%}%" to player
			send "&3Losses: &f%{cfloss::%player's uuid%}%" to player
			send "&3Profit: &f$%{cfprofit::%player's uuid%}%" to player
			send "" to player
		else:
			coinflip(player)

function coinflip(p: player):
	set {_u} to uuid of {_p}
	play sound "entity.chicken.egg" to {_p}
	open virtual chest inventory with size 3 named "&3Coinflips" to {_p}
	loop {cf::*}:
		add 1 to {_n}
		set {_i} to loop-index parsed as an offline player's head named "&3%loop-index parsed as an offline player%" with lore "&8" and "&f&lAMOUNT: &a$%{cf::%loop-index%}%"
		format gui slot ({_n} - 1) of {_p} with {_i} to close:
			{cfcooldown::%{_u}%} is not set
			set {_name} to name of event-item
			replace all "&3" in {_name} with ""
			set {_pl} to {_name} parsed as an offline player
			set {_up} to uuid of {_p}
			set {_upl} to uuid of {_pl}
			set {cfcooldown::%{_u}%} to true
			if {_pl} is not {_p}:
				if {balance::%{_up}%} is less than {cf::%{_upl}%}:
					send "&4ERROR: &cYou don't have enough money for this!"
					delete {cfcooldown::%{_u}%}
					stop
				chance of 50%:
					set {_amm} to {cf::%{_upl}%}
					delete {cf::%{_upl}%}
					loop all players:
						if name of loop-player's current inventory is "&3Coinflips":
							coinflip(loop-player)
					add 1 to {cfwin::%{_up}%}
					add 1 to {cfloss::%{_upl}%}
					add {_amm} to {balance::%{_up}%}
					add {_amm} to {cfprofit::%{_up}%}
					subtract {_amm} from {cfprofit::%{_upl}%}
					if {battlepass::%{_up}%} is 8:
						add {_amm} to {bpdetect::9::%{_up}%}
						if {bpdetect::9::%{_up}%} is greater than 500:
							set {bpdetect::9::%{_up}%} to 500
					if {battlepass::%{_up}%} is 17:
						if {_amm} is greater than or equal to 1000:
							set {bpdetect::18::%{_up}%} to true
					broadcast "&3&lBubPVP: &f%{_p}% &7beat &f%{_pl}% &7in a &3$%{_amm}% &fcoinflip!"
					play sound "block.note_block.pling" at pitch 0.95 to {_pl}
					wait 4 ticks
					play sound "block.note_block.pling" at pitch 0.67 to {_pl}
					play sound "block.note_block.pling" at pitch 1 to {_p}
					wait 6 ticks
					play sound "block.note_block.pling" at pitch 1.2 to {_p}
					wait 2 ticks
					play sound "block.note_block.pling" at pitch 1.6 to {_p}
				else:
					set {_amm} to {cf::%{_upl}%}
					delete {cf::%{_upl}%}
					loop all players:
						if name of loop-player's current inventory is "&3Coinflips":
							coinflip(loop-player)
					add 1 to {cfwin::%{_upl}%}
					add 1 to {cfloss::%{_up}%}
					add (2 * {_amm}) to {balance::%{_upl}%}
					subtract {_amm} from {balance::%{_up}%}
					add {_amm} to {cfprofit::%{_upl}%}
					subtract {_amm} from {cfprofit::%{_up}%}
					if {battlepass::%{_upl}%} is 8:
						add {_amm} to {bpdetect::9::%{_upl}%}
						if {bpdetect::9::%{_upl}%} is greater than 500:
							set {bpdetect::9::%{_upl}%} to 500
					if {battlepass::%{_upl}%} is 17:
						if {_amm} is greater than or equal to 1000:
							set {bpdetect::18::%{_upl}%} to true
					broadcast "&3&lBubPVP: &f%{_pl}% &7beat &f%{_p}% &7in a &3$%{_amm}% &fcoinflip!"
					play sound "block.note_block.pling" at pitch 0.95 to {_p}
					wait 4 ticks
					play sound "block.note_block.pling" at pitch 0.67 to {_p}
					play sound "block.note_block.pling" at pitch 1 to {_pl}
					wait 6 ticks
					play sound "block.note_block.pling" at pitch 1.2 to {_pl}
					wait 2 ticks
					play sound "block.note_block.pling" at pitch 1.6 to {_pl}
			else:
				add {cf::%{_upl}%} to {balance::%{_up}%}
				delete {cf::%{_upl}%}
				loop all players:
					if name of loop-player's current inventory is "&3Coinflips":
						coinflip(loop-player)
				coinflip({_p})
			wait 1 tick
			delete {cfcooldown::%{_u}%}

function clicker(p: player):
	set {_u} to uuid of {_p}
	play sound "entity.chicken.egg" to {_p}
	open virtual chest inventory with size 4 named "&3&lCHOOSE YOUR OPPONENT" to {_p}
	loop {clicker::*}:
		add 1 to {_n}
		set {_i} to (loop-index parsed as a player)'s head named "&3%loop-index parsed as a player%" with lore "&1" and "&f&lWAGER: &3$%loop-value%"
		format gui slot ({_n} - 1) of {_p} with {_i} to run:
			{clickercooldown::%{_u}%} is not set
			set {_k} to name of event-item
			replace all "&3" with "" in {_k}
			set {_pl} to {_k} parsed as a player
			set {_plu} to uuid of {_pl}
			set {_pu} to uuid of {_p}
			set {clickercooldown::%{_u}%} to true
			if {balance::%{_pu}%} is greater than or equal to {clicker::%{_plu}%}:
				set {claimedslots::%{_pu}%} to 0
				set {claimedslots::%{_plu}%} to 0
				loop all players:
					if name of current inventory of loop-player is "&3&lCHOOSE YOUR OPPONENT":
						clicker(loop-player)
				set {_list::*} to all integers between 0 and 44
				set {_c} to {clicker::%{_plu}%}
				delete {clicker::%{_plu}%}
				open virtual chest inventory with size 5 named "&3&lOPPONENT: &f&l%{_p}%" to {_pl}
				open virtual chest inventory with size 5 named "&3&lOPPONENT: &f&l%{_pl}%" to {_p}
				format gui slot (integers between 0 and 53) of {_p} with light gray stained glass pane named "&1"
				format gui slot (integers between 0 and 53) of {_pl} with light gray stained glass pane named "&1"
				wait 3 seconds
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_p}
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_pl}
				format gui slot (integers between 0 and 53) of {_p} with light gray stained glass pane named "&1"
				format gui slot (integers between 0 and 53) of {_pl} with light gray stained glass pane named "&1"
				format gui slot 3, 4, 5, 12, 21, 22, 23, 32, 39, 40, and 41 of {_p} with red concrete named "&1"
				format gui slot 3, 4, 5, 12, 21, 22, 23, 32, 39, 40, and 41 of {_pl} with red concrete named "&1"
				play sound "block.note_block.pling" to {_p}
				play sound "block.note_block.pling" to {_pl}
				wait 1 second
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_p}
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_pl}
				format gui slot (integers between 0 and 53) of {_p} with light gray stained glass pane named "&1"
				format gui slot (integers between 0 and 53) of {_pl} with light gray stained glass pane named "&1"
				format gui slot 3, 5, 12, 14, 21, 22, 23, 32, and 41 of {_p} with red concrete named "&1"
				format gui slot 3, 5, 12, 14, 21, 22, 23, 32, and 41 of {_pl} with red concrete named "&1"
				play sound "block.note_block.pling" to {_p}
				play sound "block.note_block.pling" to {_pl}
				wait 1 second
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_p}
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_pl}
				format gui slot (integers between 0 and 53) of {_p} with light gray stained glass pane named "&1"
				format gui slot (integers between 0 and 53) of {_pl} with light gray stained glass pane named "&1"
				format gui slot 3, 4, 5, 14, 21, 22, 23, 32, 39, 40, and 41 of {_p} with red concrete named "&1"
				format gui slot 3, 4, 5, 14, 21, 22, 23, 32, 39, 40, and 41 of {_pl} with red concrete named "&1"
				play sound "block.note_block.pling" to {_p}
				play sound "block.note_block.pling" to {_pl}
				wait 1 second
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_p}
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_pl}
				format gui slot (integers between 0 and 53) of {_p} with light gray stained glass pane named "&1"
				format gui slot (integers between 0 and 53) of {_pl} with light gray stained glass pane named "&1"
				format gui slot 3, 4, 5, 14, 21, 22, 23, 30, 39, 40, and 41 of {_p} with red concrete named "&1"
				format gui slot 3, 4, 5, 14, 21, 22, 23, 30, 39, 40, and 41 of {_pl} with red concrete named "&1"
				play sound "block.note_block.pling" to {_p}
				play sound "block.note_block.pling" to {_pl}
				wait 1 second
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_p}
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_pl}
				format gui slot (integers between 0 and 53) of {_p} with light gray stained glass pane named "&1"
				format gui slot (integers between 0 and 53) of {_pl} with light gray stained glass pane named "&1"
				format gui slot 4, 13, 22, 31, and 40 of {_p} with red concrete named "&1"
				format gui slot 4, 13, 22, 31, and 40 of {_pl} with red concrete named "&1"
				play sound "block.note_block.pling" to {_p}
				play sound "block.note_block.pling" to {_pl}
				wait 1 second
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_p}
				unformat gui slot 3, 4, 5, 12, 13, 14, 21, 22, 23, 30, 31, 32, 39, 40, and 41 of {_pl}
				format gui slot (integers between 0 and 53) of {_p} with light gray stained glass pane named "&1"
				format gui slot (integers between 0 and 53) of {_pl} with light gray stained glass pane named "&1"
				loop 15 times:
					wait 2 seconds
					set {_nu} to a random element of {_list::*}
					remove {_nu} from {_list::*}
					format gui slot {_nu} of {_p} with white concrete named "&fClick Me!" to run:
						if slot (clicked slot) of {_p}'s current inventory is white concrete:
							format gui slot (clicked slot) of {_p} with lime concrete named "&a&lCLAIMED"
							add 1 to {claimedslots::%{_pu}%}
							format gui slot (clicked slot) of {_pl} with red concrete named "&4&lCLAIMED BY OPPONENT"
					format gui slot {_nu} of {_pl} with white concrete named "&fClick Me!" to run:
						if slot (clicked slot) of {_pl}'s current inventory is white concrete:
							format gui slot (clicked slot) of {_pl} with lime concrete named "&a&lCLAIMED"
							add 1 to {claimedslots::%{_plu}%}
							format gui slot (clicked slot) of {_p} with red concrete named "&4&lCLAIMED BY OPPONENT"
				wait 2 seconds
				if {claimedslots::%{_pu}%} is greater than {claimedslots::%{_plu}%}:
					close {_p}'s inventory
					close {_pl}'s inventory
					broadcast "&3&lBubPVP: &f%{_p}% &7defeated &f%{_pl}% &7in a clicker battle for &3$%{_c}%&3!"
					add {_c} to {balance::%{_pu}%}
					add 1 to {clwin::%{_pu}%}
					add 1 to {clloss::%{_plu}%}
					add {_c} to {clprofit::%{_pu}%}
					subtract {_c} from {clprofit::%{_plu}%}
					if {battlepass::%{_pu}%} is 8:
						add {_c} to {bpdetect::9::%{_pu}%}
						if {bpdetect::9::%{_pu}%} is greater than 500:
							set {bpdetect::9::%{_pu}%} to 500
					if {battlepass::%{_pu}%} is 17:
						if {_c} is greater than or equal to 1000:
							set {bpdetect::18::%{_pu}%} to true
					play sound "block.note_block.pling" at pitch 0.95 to {_pl}
					wait 4 ticks
					play sound "block.note_block.pling" at pitch 0.67 to {_pl}
					play sound "block.note_block.pling" at pitch 1 to {_p}
					wait 6 ticks
					play sound "block.note_block.pling" at pitch 1.2 to {_p}
					wait 2 ticks
					play sound "block.note_block.pling" at pitch 1.6 to {_p}
				else:
					close {_p}'s inventory
					close {_pl}'s inventory
					broadcast "&3&lBubPVP: &f%{_pl}% &7defeated &f%{_p}% &7in a clicker battle for &3$%{_c}%&3!"
					add (2 * {_c}) to {balance::%{_plu}%}
					subtract {_c} from {balance::%{_pu}%}
					add 1 to {clwin::%{_plu}%}
					add 1 to {clloss::%{_pu}%}
					add {_c} to {clprofit::%{_plu}%}
					subtract {_c} from {clprofit::%{_pu}%}
					if {battlepass::%{_plu}%} is 8:
						add {_c} to {bpdetect::9::%{_plu}%}
						if {bpdetect::9::%{_plu}%} is greater than 500:
							set {bpdetect::9::%{_plu}%} to 500
					if {battlepass::%{_plu}%} is 17:
						if {_c} is greater than or equal to 1000:
							set {bpdetect::18::%{_plu}%} to true
					play sound "block.note_block.pling" at pitch 0.95 to {_p}
					wait 4 ticks
					play sound "block.note_block.pling" at pitch 0.67 to {_p}
					play sound "block.note_block.pling" at pitch 1 to {_pl}
					wait 6 ticks
					play sound "block.note_block.pling" at pitch 1.2 to {_pl}
					wait 2 ticks
					play sound "block.note_block.pling" at pitch 1.6 to {_pl}
				delete {claimedslots::%{_plu}%}
				delete {claimedslots::%{_plu}%}
			else:
				send "&4ERROR: &cYou don't have enough money for this!"
			wait 1 tick
			delete {clickercooldown::%{_u}%}

on quit:
	if {claimedslots::%player's uuid%} is set:
		delete {claimedslots::%player's uuid%}

on inventory move:
	name of player's current inventory contains "CHOOSE YOUR OPPONENT" or "OPPONENT" or "Coinflips"
	cancel event

command /clicker [<text>]:
	trigger:
		if arg-1 parsed as a number is an integer:
			if arg-1 parsed as a number is greater than or equal to 100:
				if {balance::%player's uuid%} is greater than or equal to arg-1 parsed as a number:
					if {clicker::%player's uuid%} is not set:
						set {clicker::%player's uuid%} to arg-1 parsed as a number
						subtract {clicker::%player's uuid%} from {balance::%player's uuid%}
						send "&3&lBubPVP: &fYou successfully started a clicker duel! Wait for an opponent to battle you!"
						open virtual chest inventory with size 3 named "&3&lWAITING FOR OPPONENT..." to player
						format gui slot 10, 11, 12, 13, 14, 15, and 16 of player with red concrete named "&4&lCLOSE INVENTORY TO CANCEL"
						loop all players:
							if name of current inventory of loop-player is "&3&lCHOOSE YOUR OPPONENT":
								clicker(loop-player)
					else:
						send "&3&lBubPVP: &fYou already have an active wager!"
				else:
					send "&3&lBubPVP: &fYou don't have enough money for this!"
			else:
				send "&3&lBubPVP: &fYou must choose a wager that is &3$100 &for higher!"
		else if arg-1 is "stat" or "stats":
			play sound "entity.chicken.egg" to player
			send "" to player
			send "&3&lCLICKER STATS" to player
			send "" to player
			send "&3Wins: &f%{clwin::%player's uuid%}%" to player
			send "&3Losses: &f%{clloss::%player's uuid%}%" to player
			send "&3Profit: &f$%{clprofit::%player's uuid%}%" to player
			send "" to player
		else:
			clicker(player)

on inventory close:
	if name of event-inventory is "&3&lWAITING FOR OPPONENT...":
		send "&3&lBubPVP: &fYou have successfully cancelled your clicker duel!" to player
		add {clicker::%player's uuid%} to {balance::%player's uuid%}
		delete {clicker::%player's uuid%}
		loop all players:
			if name of current inventory of loop-player is "&3&lCHOOSE YOUR OPPONENT":
				clicker(loop-player)