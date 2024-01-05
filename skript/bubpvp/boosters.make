#BOOSTERS.SK

#VARS
#{booster::type::*} type of booster
#{booster::timespan::*} how long booster lasts
#{booster::bought::*} who created / bought the booster
#{booster::multiplier::*} multiplier of booster
#{booster::started::*} when the booster started

command /booster <text> [<text>] [<number>] [<offline player>] [<timespan>]:
	usage: &c/booster <create, delete> <type> <boost amount: EX: 2> <player [most likely purchaser]> <time (how long booster lasts)>
	permission: skript.booster
	permission message: &cYou are not permitted to perform this command!
	trigger:
		if arg-1 is "create":
			if arg-3 is set:
				if arg-4 is set:
					if arg-5 is set:
						if arg-2 is "mine":
							boosterCreate(arg-2, arg-3, arg-5, arg-4)
						else if arg-2 is "xp":
							boosterCreate(arg-2, arg-3, arg-5, arg-4)
						else if arg-2 is "kill":
							boosterCreate(arg-2, arg-3, arg-5, arg-4)
						else:
							send "&4ERROR: &cThe only valid booster types are ''mine'', ''kill'' and ''xp''" to player
		else if arg-1 is "deleteall":
			boosterDeleteAll()
		else if arg-1 is "delete":
			arg-2 is set
			arg-2 parsed as an integer is greater than 0
			boosterDelete(arg-2 parsed as a number)
		else:
			send "&4ERROR: &cInvalid argument"

command /boosters:
	trigger:
		if {booster::type::*} is not set:
			send "%nl%&3There are no active boosters at this current time.%nl%%nl%&3Purchase one on our webstore &b(/buy)%nl%" to player
		else:
			send "%nl%&3&lCURRENT BOOSTERS:%nl%" to player
			loop {booster::type::*}:
				send "&8• &3x%{booster::multiplier::%loop-index%}% &3%formatBoosterType({booster::type::%loop-index%})% &3booster &f- &3%difference between now and {booster::timespan::%loop-index%} after {booster::started::%loop-index%}%%nl%" to player
				set {_th} to {booster::timespan::%loop-index%} before {booster::started::%loop-index%}

function formatBoosterType(t: text) :: text:
	if {_t} is "mine":
		return "Fortune"
	else if {_t} is "xp":
		return "XP"
	else if {_t} is "kill":
		return "Kill"

function boosterCreate(type: text, multiplier: number, time: timespan, bought: offline player):
	add {_type} to {booster::type::*}
	add {_multiplier} to {booster::multiplier::*}
	add {_bought} to {booster::bought::*}
	add {_time} to {booster::timespan::*}
	add now to {booster::started::*}
	broadcast "&3-------------------------"
	broadcast ""
	broadcast "&f%{_bought}% &7purchased a"
	broadcast "&3x%{_multiplier}% &3global %formatBoosterType({_type})%"
	broadcast "&3booster &7that lasts for &3%{_time}%!"
	broadcast ""
	broadcast "&3Thank you! &f(/buy)"
	broadcast ""
	broadcast "&3-------------------------"
	play sound "entity.firework_rocket.launch" to all players
	wait 25 ticks
	play sound "entity.firework_rocket.blast" to all players

function boosterDelete(n: number):
	execute console command "/broadcast &3&lBubPVP: &3%{booster::bought::%{_n}%}%&3's &3global &3x%{booster::multiplier::%{_n}%}% &3%formatBoosterType({booster::type::%{_n}%})% &3Booster &fhas expired. Buy boosters on our webstore &b(/buy)!"
	delete {booster::type::%{_n}%}
	delete {booster::multiplier::%{_n}%}
	delete {booster::bought::%{_n}%}
	delete {booster::timespan::%{_n}%}
	delete {booster::started::%{_n}%}

function boosterDeleteAll():
	loop {booster::type::*}:
		delete {booster::type::%loop-index%}
		delete {booster::multiplier::%loop-index%}
		delete {booster::bought::%loop-index%}
		delete {booster::timespan::%loop-index%}
		delete {booster::started::%loop-index%}
	execute console command "/broadcast &3&lBubPVP: &fAll boosters have been deleted"

function getBestBooster(t: text) :: number:
	set {_n} to 0
	loop {booster::type::*}:
		if loop-value is {_t}:
			if {booster::multiplier::%loop-index%} is greater than {_n}:
				set {_n} to {booster::multiplier::%loop-index%}
	return {_n}

every 3 seconds:
	loop {booster::started::*}:
		if time since loop-value is more than {booster::timespan::%loop-index%}:
			boosterDelete(loop-index parsed as a number)

