import {world,system} from "@minecraft/server";
import {ActionFormData} from "@minecraft/server-ui";
import data from "./data.js";

world.events.beforeItemUse.subscribe(ev => {
    if(ev.item.typeId === "sta_magic:magic_wand"){
        let pl = ev.source;
        let magicType = world.scoreboard.getObjective("magicType" + pl.getComponent("inventory").container.getItem(pl.selectedSlot).data).getScore(pl.scoreboard);
        try {
            for(let i = 0; i < data.magicData[magicType].summonData.length; i++){
                pl.runCommandAsync(`execute as @s at @s ${data.magicData[magicType].resetRotateX?"rotated ~ 0 ":""} run summon sta_magic:magic_bullet ${data.magicData[magicType].summonEntityName} ${data.magicData[magicType].summonData[i][0]} ${data.magicData[magicType].summonData[i][1]} ${data.magicData[magicType].summonData[i][2]}`);
                pl.runCommandAsync(`execute at @s as @e[type=sta_magic:magic_bullet,tag=!setUp,c=1] rotated ~${data.magicData[magicType].summonData[i][3]} ~${data.magicData[magicType].summonData[i][4]} run tp @s ~~~~~`);
                pl.runCommandAsync(`scoreboard players operation @e[type=sta_magic:magic_bullet,tag=!setUp,c=1] PlayerID = @s PlayerID`);
                pl.runCommandAsync(`tag @e[type=sta_magic:magic_bullet,tag=!setUp,c=1] add setUp`);
            }
        } catch (e) {
            pl.kill();
            world.say(`error: ${pl.nameTag} used unexpected magic.`);
        }
    }
})

system.runSchedule(function tickEvent(){
    for(let player of world.getPlayers()){
        const sneakTemp = sneakEndTime(player);
        if(player.getComponent("inventory").container.getItem(player.selectedSlot)?.typeId === "sta_magic:magic_wand" && sneakTemp >= 1 && sneakTemp <= 20){
            let wandChange = player.getComponent("inventory").container.getItem(player.selectedSlot);
            wandChange.data = (player.getComponent("inventory").container.getItem(player.selectedSlot).data + 1) % 5;
            player.getComponent("inventory").container.setItem(player.selectedSlot, wandChange);
        }else if(player.getComponent("inventory").container.getItem(player.selectedSlot)?.typeId === "sta_magic:magic_wand" && sneakTemp >= 21){
            magicSetFornFunc(player);
        }
        player.runCommandAsync("title @a actionbar 現在選択中の魔法スロット:スロット"+(player.getComponent("inventory").container.getItem(player.selectedSlot).data+1)+"、魔法名:"+data.magicData[world.scoreboard.getObjective("magicType" + player.getComponent("inventory").container.getItem(player.selectedSlot).data).getScore(player.scoreboard)]?.name)
    }
});

function unzipMagicDataScore(getFrom){
    let s = world.scoreboard.getObjective("gotMagicData").getScore(getFrom.scoreboard);
    let r = [50];
    for(let i = 0; i < 25; i++){
        r[i] = s % 2;
        s = Math.floor(s / 2);
    }
    if(s % 2 == 1){
        for(let i = 25; i < 50; i++){
            r[i] = r[i - 25];
        }
    }
    return r;
}

function magicSetFornFunc(player) {
    let magicSetForm = new ActionFormData()
        .title("魔法の杖メニュー")
        .button("1番目の魔法設定")
        .button("2番目の魔法設定")
        .button("3番目の魔法設定")
        .button("4番目の魔法設定")
        .button("5番目の魔法設定");
    magicSetForm.show(player).then(res => {
        if(!res.canceled){
            let magicSet = new ActionFormData().title(`${res.selection+1}番目の魔法設定`);
            let magicDataUnziped = unzipMagicDataScore(player);
            for(let i = 0; i < 50; i++){
                if(magicDataUnziped[i] == 1){
                    magicSet = magicSet.button(data.magicData[i].name);
                }
            }
            magicSet.show(player).then(resp => {
                if(!resp.canceled){
                    player.runCommandAsync(`scoreboard players set @s magicType${player.getComponent("inventory").container.getItem(player.selectedSlot).data} ${resp.selection}`);
                } else {
                    magicSetFormFunc();
                }
            })
        }
    });
}

function sneakEndTime(player) {
    if(player.isSneaking){
        player.sneakingTime++
        return 0;
    } else {
        const temp = player.sneakingTime;
        player.sneakingTime = 0;
        return temp;
    }
}