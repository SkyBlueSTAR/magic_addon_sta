#セットアップ
scoreboard objectives add magic_limit dummy
scoreboard objectives add magic_time dummy
scoreboard objectives add magicType0 dummy
scoreboard objectives add magicType1 dummy
scoreboard objectives add magicType2 dummy
scoreboard objectives add magicType3 dummy
scoreboard objectives add magicType4 dummy
scoreboard objectives add gotMagicData dummy
scoreboard objectives add PlayerID dummy

#プレイヤー初期設定
scoreboard players add @a gotMagicData 0
scoreboard players add @a magicType0 0
scoreboard players add @a magicType1 0
scoreboard players add @a magicType2 0
scoreboard players add @a magicType3 0
scoreboard players add @a magicType4 0
execute as @r[tag=!login] run scoreboard players add PlayerID PlayerID 1
execute as @r[tag=!login] run scoreboard players operation @s PlayerID = PlayerID PlayerID
tag @a[tag=!login,scores={PlayerID=0..}] add login

#魔法弾初期設定
scoreboard players set @e[type=sta_magic:magic_bullet,name=fire_1] magic_limit 20
scoreboard players set @e[type=sta_magic:magic_bullet,name=fire_2] magic_limit 30
scoreboard players set @e[type=sta_magic:magic_bullet,name=fire_3] magic_limit 40
scoreboard players set @e[type=sta_magic:magic_bullet,name=fire_4] magic_limit 10
tag @e[type=sta_magic:magic_bullet,name=fire_1] add move
tag @e[type=sta_magic:magic_bullet,name=fire_2] add move
tag @e[type=sta_magic:magic_bullet,name=fire_3] add move
tag @e[type=sta_magic:magic_bullet,name=fire_4] add move

#魔法弾関連-時間設定
scoreboard players add @e[type=sta_magic:magic_bullet] magic_time 1

#魔法弾関連-移動
execute as @e[type=sta_magic:magic_bullet,tag=move,scores={magic_time=2..},rxm=-90,rx=-1] at @s run tp @s ~~~~~-10
execute as @e[type=sta_magic:magic_bullet,tag=move,scores={magic_time=2..},rxm=1,rx=90] at @s run tp @s ~~~~~10
execute as @e[type=sta_magic:magic_bullet,tag=move] at @s run tp @s ^^^1

#魔法弾関連-パーティクル
execute as @e[type=sta_magic:magic_bullet,name=fire_1] at @s run particle minecraft:mobflame_single ~~1~
execute as @e[type=sta_magic:magic_bullet,name=fire_2] at @s run particle minecraft:mobflame_single ~~1~
execute as @e[type=sta_magic:magic_bullet,name=fire_3] at @s run particle sta_magic:fire_big ~~1~
execute as @e[type=sta_magic:magic_bullet,name=fire_4] at @s run particle minecraft:mobflame_single ~~1~

#魔法弾関連-ダメージ
execute at @e[type=sta_magic:magic_bullet,name=fire_1] run scoreboard players add @e[r=1] PlayerID 0
execute as @e[type=sta_magic:magic_bullet,name=fire_1] at @e[type=!sta_magic:magic_bullet,type=!item,type=!armor_stand,r=1] unless score @s PlayerID = @e[c=1] PlayerID run tag @s add hit
execute at @e[type=sta_magic:magic_bullet,name=fire_1] as @e[type=!sta_magic:magic_bullet,type=!item,type=!armor_stand,r=1] unless score @s PlayerID = @e[c=1] PlayerID run damage @s 3 fire entity @e[c=1]
execute at @e[type=sta_magic:magic_bullet,name=fire_2] run scoreboard players add @e[r=1] PlayerID 0
execute as @e[type=sta_magic:magic_bullet,name=fire_2] at @e[type=!sta_magic:magic_bullet,type=!item,type=!armor_stand,r=1] unless score @s PlayerID = @e[c=1] PlayerID run tag @s add hit
execute at @e[type=sta_magic:magic_bullet,name=fire_2] as @e[type=!sta_magic:magic_bullet,type=!item,type=!armor_stand,r=1] unless score @s PlayerID = @e[c=1] PlayerID run damage @s 1 fire entity @e[c=1]
execute at @e[type=sta_magic:magic_bullet,name=fire_3] run scoreboard players add @e[r=1] PlayerID 0
execute as @e[type=sta_magic:magic_bullet,name=fire_3] at @e[type=!sta_magic:magic_bullet,type=!item,type=!armor_stand,r=1] unless score @s PlayerID = @e[c=1] PlayerID run tag @s add hit
execute at @e[type=sta_magic:magic_bullet,name=fire_3] as @e[type=!sta_magic:magic_bullet,type=!item,type=!armor_stand,r=1] unless score @s PlayerID = @e[c=1] PlayerID run damage @s 8 fire entity @e[c=1]
execute at @e[type=sta_magic:magic_bullet,name=fire_4] run scoreboard players add @e[r=1] PlayerID 0
execute as @e[type=sta_magic:magic_bullet,name=fire_4] at @e[type=!sta_magic:magic_bullet,type=!item,type=!armor_stand,r=1] unless score @s PlayerID = @e[c=1] PlayerID run tag @s add hit
execute at @e[type=sta_magic:magic_bullet,name=fire_4] as @e[type=!sta_magic:magic_bullet,type=!item,type=!armor_stand,r=1] unless score @s PlayerID = @e[c=1] PlayerID run damage @s 5 fire entity @e[c=1]

#魔法弾関連-魔法弾kill
execute as @e[type=sta_magic:magic_bullet] if score @s magic_time > @s magic_limit run tp @s 0 -1000000 0
execute as @e[type=sta_magic:magic_bullet,tag=move] at @s positioned ~~1~ unless block ^^^1 air -1 run tp @s 0 -1000000 0
tp @e[type=sta_magic:magic_bullet,tag=hit] 0 -1000000 0
kill @e[type=sta_magic:magic_bullet,y=-10000000,dy=9999900]