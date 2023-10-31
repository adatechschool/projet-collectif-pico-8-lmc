pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
function _init()
	create_player()
	init_msg()
	camera()scene="menu"
	i=1
	score=0
	energy=10
	state=0
end

function _update()
	if scene=="menu" then	update_menu()
	elseif scene=="game" then
		if #message==0 then
			player_movement()
		end
		check_flag(flag,x,y)
		update_camera()
		update_msg()
	end
	if (state==1) then update_endgame()
	end
	if (energy==0) then
		create_msg("","tu as besoin de repos")	
			if (btn(❎)) then
				_init()
			end	
	end
end

function _draw()
	if scene=="menu" then	draw_menu()
	elseif scene=="game" then
		cls()
		draw_map()
		draw_player()
		camera()draw_msg()
		rectfill(114,1,126,7,0)
		print(score,115,2,10)
		rectfill(1,1,9,7,0)
		print(energy,2,2,8)
	end
	if (state==1) draw_endgame()
end
-->8
--map

function draw_map()
map(0,0,0,0,128,64)
end

function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

function update_camera()
	local camx =mid(0,p.x-7.5,127-15)
	local camy =mid(0,p.y-7.5,63-15)
	camera(camx*8,camy*8)
end

function next_tiles(x,y)
	local sprite=mget(x,y)
	mset(x,y,sprite+1)
end

function pick_up_shit(x,y)
	next_tiles(x,y)
	p.shit+=1
	score+=10
	sfx(0)
end

function trash_bin(x,y)
	p.shit=0
	score+=50
	sfx(2)
end

function end_game(x,y)
	if score<100 then
		create_msg ("","il semblerait qu'il reste\n des choses faire...")
	end
	if score>=100 then
		create_msg("","fini!")
		state+=1
	end
end
	

-->8
--player

function create_player()
 p={
 	x=5,
 	y=4,
 	sprite=2,
 	speed=0.5,
 	shit=0,
 	init_sprite=0,
 }
end

function player_movement()
	newx=p.x
	newy=p.y
	
	if (btnp(⬆️)) newy-=1
	if (btnp(⬇️)) newy+=1
	if (btnp(⬅️)) newx-=1
	if (btnp(➡️)) newx+=1
	
	interact(newx,newy)
	
	if not check_flag(0,newx,newy)then
		p.x=mid(0,newx,127)
		p.y=mid(0,newy,63)
	else
		sfx(1)	
	end
end

function interact(x,y)
	if check_flag(1,x,y) then
		pick_up_shit(x,y)
	elseif check_flag(2,x,y)
	and p.shit>0 then
		trash_bin(x,y)
	end
	--msg
	if x==8 and y==10 then
		create_msg("dog","ouaf ouaf!")
	end
	if x==8 and y==19 then
		if p.init_sprite==193 then
			create_msg("vieille feministe","salut")
		end
	 if  p.init_sprite==209 then
		create_msg("vieille feministe","mm..")
	 energy-=1
	 end
	end
	if check_flag(4,x,y) then
		energy-=1
		sfx(4)
	end
	if check_flag(3,x,y) then
		end_game(x,y)
	end
end

function draw_player()	
	spr(p.sprite,p.x*8,p.y*8)
	if (btn(⬆️)) then
	 p.sprite = p.init_sprite + 1
		spr(p.sprite,p.x*8,p.y*8)
	end
	if (btn(⬅️)) then
	 p.sprite = p.init_sprite + 3
		spr(p.sprite,p.x*8,p.y*8)
	end	
	if (btn(➡️)) then
	 p.sprite = p.init_sprite + 2
		spr(p.sprite,p.x*8,p.y*8)
	end	
	if (btn(⬇️)) then
	 p.sprite = p.init_sprite
		spr(p.sprite,p.x*8,p.y*8)
	end		
end


-->8
--messages

function init_msg()
message={}
create_msg("but du jeu",
"rendez vous au safe place\nderriere les portes dorees")
end

function create_msg(name,...)
msg_title=name
message={...}
end

function update_msg()
	if (btnp(❎)) then
		deli(message,1)
	end	
end

function draw_msg()
	if message[1] then
		local y=100
			if p.y%16>=9 then
				y=10
			end	
		rectfill(6,y,
		6+#msg_title*4,y+6,2)	
		print (msg_title,7,y+1,7)
		rectfill(2,y+9,125,y+21,13)
		print (message[1],3,y+10,7)
	end	
end
-->8
--choix des joueurs

function draw_menu()
	local x=63
	local y=63
	cls()
	print("use ⬅️ or ➡️ to choose\noptions",30,63)
	p.sprite=193
	spr(p.sprite,x-30,y+15)
	p.sprite=209
	spr(p.sprite,x-20,y+15)
	p.sprite=225
	spr(p.sprite,x-10,y+15)
	p.sprite=241
	spr(p.sprite,x,y+15)
	if i==1 then
		p.sprite=192
		p.init_sprite=193
		spr(p.sprite,x-30,y+15)
	end
	if i==2 then
		p.sprite=208
		p.init_sprite=209
		spr(p.sprite,x-20,y+15)
	end
	if i==3 then
		p.sprite=224
		p.init_sprite=225
		spr(p.sprite,x-10,y+15)
	end
	if i==4 then
		p.sprite=240
		p.init_sprite=241
		spr(p.sprite,x,y+15)
	end
end

function update_menu()
	if btnp(⬅️) then
	 if (i>1) then
	 	i-=1
	 	sfx(3)
	 end
 end
	if btnp(➡️) then
	 if (i<4) then
	 	i+=1
	 	sfx(3)
	 end
 end
	if btnp(❎) then
		scene="game"
		p.sprite+=1
	end
end
-->8
--end game

function update_endgame()
	if (btn(❎)) _init()
end

function draw_endgame()
cls()
print (score,50,50,7)
print ("appuie sur x pour\n rejouer",50,60,7)
end
__gfx__
000000003b33b33b55aaaaa5cccccccc044444444444444444444444444444440000000000000055566654665444445555000000444444404444444400000000
000000003b33b33b66ffffa6cccccccc05650050050050050050050050050050000000000000a8555666446644ffff4555a80000544444404444444500000000
0070070033b33b3366cfffaaccc7cccc0565067067067067067067067067067000000000000055554444404444f1f14555550000444444404444444400000000
0007700033b33b3355ffffaacc7ccccc0565066066066066066066066066066000000000000055556544444444ffff4555550000444444404444444400000000
000770003b33b33b5eeeeeaaccccccc70565566566566566566566566566566000000000000065665544445555aaaa5566560000444444a04a44444400000000
0070070033333333eeeeeea6ccccc7cc055555555555555555555555555555500000000000005555564654665544d45555550000444444404444444400000000
0000000054545454eee1f156cccc7ccc056555555555555555555555555555500000000000005555564454465aaaaaa555550000544444404444444500000000
000000005454545455777755cccccccc056500500500500500500500500500505000000000005555555555555545545555550000444444404444444400000000
5a555a55666556666665666555555555056506706706706706706706706706705000000054434434aaffffaaaaa88aaa40000004aaaaaaa0aaaaaaaa00000000
55a5a555555555555555555533333333056506606606606606606606606606600000000044333343aaffffaaa88888aa455555545aaaaaa0aaaaaaa500000000
22292225656665666566656637777773055506606606606606606606606606600000000043344533affffffaaa888aaa40000004aaaaaaa0aaaaaaaa00000000
eeeaee25656665666566656637a0a073056556656656656656656656656656600000000033444453aaffffaa9a939a9a45555554aaaaaaa0aaaaaaaa00000000
eeeaee25555455555555555537777773056555555555555555555555555555500000000034444445a555555a9a9a3a9a40000004aaaaaa404aaaaaaa00000000
aaaaaa95564446666665666533333333056500500500500500500500500500500000000039999995a55ff55a9a939a9a45555554aaaaaaa0aaaaaaaa00000000
eeeaee25544444666665666503333330056506706706706706706706706706700000000033344533aa1141aa9a9a3a9a400000045aaaaaa0aaaaaaa500000000
eeeaee25555555555555555555555555056506606606606606606606606606600000000043344534a77a477a9a939a9a45555554aaaaaaa0aaaaaaaa00000000
333343335545554533aaaa433b34b33b05550660660660660660660660660660000000003544434433b333b33443344445444344aaaaaaaa5555555500000000
33334333444444443aa99aa43b44433b056556656656656656606656656656600000000033434443bba33ba34433334444444454aaaaaaaa5555555500000000
3333433345554555aa9aa9aa33b43b330565555555555555555555555555555000000000344444443b33333343333b34444444449a9a9a9a5555555500000000
344a4a4445554555a9a99a9a33444b33056000000500000050000005000000500000000044478244333333334333bb34454444449a9a9a9a5555555500000000
3336663344444444a9a99a9a3b34b33b056066666706666670666667066666700000000044887824333b3b3344354344544444449a9a9a9a7755775500000000
b33aaa3555455545aa9aa9aa334443330550666676066667606666760666676000000000487888723b3abb3334454535434444549a9a9a9a5555555500000000
3b3b4353554555453aa99aa4545454540560666666066666606666660666666000000000444882243bbb333333354333445444349a9a9a9a5555555500000000
33b345334444444433aaaa4354545454056566666656666665666666566666600000000034388234333b333a33554433444444449a9a9a9a5555555500000000
999999a9564444566aaaaaa567777756056555555555555555555555555555500000000055575555999999990888888055555555555555556665666500000000
9999999954ffff456aaaff5565447756056555555555000000005555555555500000000055575555999999998888888855655555555555555555555500000000
9a9999996ffcfcf55aaffc5655044755055000000055044444444400000000500000000055555555944449678888888855555555556666556566656600000000
9999999965ffff655aaaff5656447765056066666675046670667406666666700000000055575555944449669999999955555555556677556566656600000000
99a99999f116611f55111155561111550560666667650466606664066666676000000000555755559444496696799679555575558676776a5555555500000000
9999999955116155661f166565614166056066666665046660666406666666600000000055575555944449669669966955555757666666666665666500000000
999999a9560000666660066565500566066566666665046660666406666666600000000055555555944449999669966955555575666666666665666500000000
99999999554554555554445555ddd555055555555555546660666455555555500000000055575555944449999999999955555555515555155555555500000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10b2b292b2b2b2c2c2c292c2c291b210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10b201c2c2b291c2c2c2c2b2c2b2b2100000000000000000000000000000001000000000000f0000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10b292c2c2c2b2c2c2b2d291c2c2c210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10c2c2d2c2c2d2c2c2c2c2d2c2c29210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10d2d2c2d2c2d2d2d2d2d2d2d2d2d210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10d2b1d2d2d2d2d2d2d2d2d2d2d2d210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10d2d2d2d2b1d2d2d2d2b1d28cd2d2c2000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10b1d2d2d2d2d2d2d2d2d2d2d2d2d2c2000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10d2b1d2d2d2d2d2d2d2d2d2d2d2b110000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10d2d2b1b1b1b1a1d2b1b1b1b1b1d210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10d28cd2d2d2d2d2d2d2d2d2d2d2d210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10d2b1d2d2d2d2d2d2d2d2d2b1d2d210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10d2d2d2d2d2d2d2d2d2d2d2d2d2d210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10b2c2c2d2d2b2c2b2b2b2d2d2d2c210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10c2d2b2d2c2c2c2c2c2b2c2b2d2c210000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
101010101010d1e11010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbebebeb00e0e0e00e0e0e0000e0e0e00e0e0e000000000000ddddd000000000aaaaaaaa55e7ee55000000000000000000000000000000000000000000000000
beeeeeeb0eeeeee00eeeeee00eeeeee00eeeeee000000000066666d000444440aaaaaaaa57eeee75000000000000000000000000000000000000000000000000
be4444eb0e4444e00eeeeee00e444400004444e0ee000007060006d0004000409aa00aaaeee55ee7000000000000000000000000000000000000000000000000
be4d4deb0e4d4de00eeeeee00e44d400004d44e00ee54cc706ddd6d00440004490070aa9e75555ee000000000000000000000000000000000000000000000000
ba4444ab0a4444a00a4444a00ea4440000444ae0eee44cc7066666d00440004499a00099ee5555e7000000000000000000000000000000000000000000000000
4cccccc44cccccc44cccccc400cccc0000cccc000ee4ac4706ddd6d0000000009a90000a7ee55eee000000000000000000000000000000000000000000000000
bbccccbb00cccc0000cccc0000cc4c0000c4cc00eeeeecc706666600000000009a9a0a9a5eee7e75000000000000000000000000000000000000000000000000
bb7bb7bb007007000070070000777770077777000eeeecc700000000000000009a9a9a9a557eee55000000000000000000000000000000000000000000000000
bddddddb0dddddd00dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddfffffdddfffffddddddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd4ff4fddd4ff4fddddddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddfffffdddfffffddddddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddbbdddddd000ddddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bd6666fb0d6666f00f6666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bd6666bb0d666600006666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb6bb6bb006006000060060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb44444b004444400044444000000040040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b4ffff4b04ffff400444444004444440044444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bff3f3fb0ff3f3f00444444004ffff0000ffff400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbffffbb00ffff000f6666f004ff3f0000f3ff400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f666666f566666655666666504ffff0000ffff400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5b6666b5606666066566665600565600006565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5b1111b5f011110f50111105005f56000065f5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5b1bb1b5501001055010010500151110011151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001010105010101000101010100000001020005010101010001010100090900010101010101010100110001000000000001010101010101000000010011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2121212121212101012301010101230121213435363721212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213c3c3e3e3c3c2b303030303030300104050607040506070405060405060721000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213c3c3e3e3c3c2b302b2b03032b300114151617141516171415161415161721000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213c3c3e3e3c3c2b3030302b2b30302324252627242526272425262425262721000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213e3e3e3e3e3e3e3e113e3e3e3e3e2134353637343536373435363435363721000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213c3c3e3e3c3c2b3e3e040506073e21133e3e3e133e3e3e133e3e3e3e3e1321000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213c3c3e3e3c3c2b3e3e141516173e21092e3d2e2e2e2e2e2e2e3d2e2e2e0c21000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2121213e3e2121212121242526273e21092e2e2e2e2e2e2e2e2e2e2e2e2e0c21000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213e3e3e3e3e3e3e3e11343536373e3e3e3e3e3e32313133393e3e3e3e3e3e21000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213e3e3e3e113e3e3e3e3e3e3e3e3e213e3e3e3e3e3e3e3e393e3e3e3e3e3e21000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21040506073e3e3e0a3e3e3e3e3e3e21040506040506073e393e040506073e21000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21141516173e03030303033e3e113e21141516141516173e393e141516173e21000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21242526273e3e3e3e113e3e3e3e3e21242526242526273e393e242526273e21000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21343536373e3e3e3e3e3e133e3e3e21343536343536373e393e343536373e21000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21c93e3e3e3e3e3e3e3e3e3e3e3e3e21c93e3e3e3e3e3e3e393e3e3e3e3e3e21000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21212121212121211c1c212121212121212121212121213c3c21212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213b3b3b3b3b3b3b3e393b3b3b3b3b2100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213a3a3a3a3a3a3a3e393a3a3a3a3a2100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21c93e3e3e3e3e3e3e393e3e3e3e3e2100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212e2e2e2e2e2e2e0b392e2e2e2e2e2100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213b3b3b3b3b3b3b3e393b3b3b3b3b2100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213a3a3a3a3a3a3a3e393a3a3a3a3a2100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213e3e3e3e3e3e3e3e3931023e3e102100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212e2e2e2e2e2e2e2e392e2e2e2e2e3e00000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
213e3e3e3e3e3b3b3e393e3e3e3e3e3e00000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212a2a2a2a2a3a3a3e393b3b3e3e3e2300000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
012a222a2c2c2c2c2c2a3a3a2a2a220100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b2a2a2a202a2a2c2c2c2c2c2c2a2a0100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
012a2a2a2a2a2a2c2c2a2a2a2a202a2b00000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b202a222a2a222c2c2a222a2a222a0100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
232a2a2a2a2a2a2c2c202a2a2a2a2a0100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01012b01232b012c2c0101232b01230101010101010101000001010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000250503135000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000012710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000000a640016400064000600006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000000000000000002a07000000000001b07000000000002d070000002d0700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000002745029450254500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01424344

