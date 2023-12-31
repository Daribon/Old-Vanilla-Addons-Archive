﻿--[[
--	Atlas Localization Data (Chinese)

-- Initial translation by DiabloHu

-- Version : Chinese (by DiabloHu)
-- Last Update : 09/26/2005

--]]





if ( GetLocale() == "zhCN" ) then






ATLAS_TITLE = "Atlas";
ATLAS_SUBTITLE = "副本地图";
ATLAS_DESC = "Atlas 是一款副本地图查看器";
ATLAS_NAME = ATLAS_TITLE.." v"..ATLAS_VERSION;

ATLAS_OPTIONS_BUTTON = "设置";

BINDING_HEADER_ATLAS_TITLE = "Atlas 按键设置";
BINDING_NAME_ATLAS_TOGGLE = "开启/关闭 Atlas";
BINDING_NAME_ATLAS_OPTIONS = "切换设置";

ATLAS_SLASH = "/atlas";
ATLAS_SLASH_OPTIONS = "设置";

ATLAS_STRING_LOCATION = "副本位置";
ATLAS_STRING_LEVELRANGE = "等级范围";
ATLAS_STRING_PLAYERLIMIT = "人数上限";

ATLAS_BUTTON_TOOLTIP = "开启/关闭 Atlas";

ATLAS_OPTIONS_TITLE = "Atlas 设置";
ATLAS_OPTIONS_SHOWBUT = "在小地图周围显示Atlas图标";
ATLAS_OPTIONS_AUTOSEL = "自动选择副本地图";
ATLAS_OPTIONS_BUTPOS = "图标位置";
ATLAS_OPTIONS_TRANS = "透明度";
ATLAS_OPTIONS_DONE = "完成";





local BLUE = "|cff6666ff";
local GREY = "|cff999999";
local GREN = "|cff66cc33";
local INDENT = "　";

AtlasText = {
	BlackfathomDeeps = {
		ZoneName = "黑暗深渊";
		Location = "灰谷";
		LevelRange = "20-27";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		GREY.."1) 加摩拉";
		GREY.."2) 潮湿的便笺";
		GREY.."3) 萨利维丝";
		GREY.."4) 银月守卫塞尔瑞德";
		GREY.."5) 格里哈斯特";
		GREY.."6) 洛古斯·杰特 (多个位置)";
		GREY.."7) 奇怪的水球";
		GREY..INDENT.."阿奎尼斯男爵";
		GREY.."8) 梦游者克尔里斯";
		GREY.."9) 瑟拉吉斯";
		GREY.."10) 阿库迈尔";
	};
	BlackrockDepths = {
		ZoneName = "黑石深渊";
		Location = "黑石山";
		LevelRange = "48-56";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		GREY.."1) 洛考尔";
		GREY.."2) 卡兰·巨锤";
		GREY.."3) 指挥官哥沙克";
		GREY.."4) 温德索尔元帅";
		GREY.."5) 审讯官格斯塔恩";
		GREY.."6) 法律之环";
		GREY.."7) 弗兰克罗恩·铸铁的雕像";
		GREY..INDENT.."控火师罗格雷恩 (稀有)";
		GREY.."8) 黑色宝库";
		GREY.."9) 弗诺斯·达克维尔";
		GREY.."10) 黑铁砧";
		GREY..INDENT.." 伊森迪奥斯";
		GREY.."11) 贝尔加";
		GREY.."12) 暗炉之锁";
		GREY.."13) 安格弗将军";
		GREY.."14) 傀儡统帅阿格曼奇";
		GREY.."15) 黑铁酒吧";
		GREY.."16) 弗莱拉斯大使";
		GREY.."17) 无敌的潘佐尔 (稀有)";
		GREY.."18) 召唤者之墓";
		GREY.."19) 讲学厅";
		GREY.."20) 玛格姆斯";
		GREY.."21) 达格兰·索瑞森大帝";
		GREY..INDENT.." 铁炉堡公主茉艾拉·铜须";
		GREY.."22) 黑熔炉";
		GREY.."23) 熔火之心 (团队副本)";
	};
	BlackrockSpireLower = {
		ZoneName = "黑石塔 (下层)";
		Location = "黑石山";
		LevelRange = "53-60";
		PlayerLimit = "15";
		BLUE.."A) 入口";
		GREY.."1) 瓦罗什";
		GREY.."2) 尖锐长矛";
		GREY.."3) 欧莫克大王";
		GREY.."4) 暗影猎手沃什加斯";
		GREY..INDENT.."第五块摩沙鲁石板";
		GREY.."5) 指挥官沃恩";
		GREY..INDENT.."第六块摩沙鲁石板";
		GREY.."6) 烟网蛛后";
		GREY.."7) 水晶之牙 (稀有)";
		GREY.."8) 乌洛克";
		GREY.."9) 军需官兹格雷斯";
		GREY.."10) 奴役者基兹鲁尔";
		GREY..INDENT.." 哈雷肯";
		GREY.."11) 维姆萨拉克";
		GREY.."12) 班诺克·巨斧 (稀有)";
	};
	BlackrockSpireUpper = {
		ZoneName = "黑石塔 (上层)";
		Location = "黑石山";
		LevelRange = "53-60";
		PlayerLimit = "15";
		BLUE.."A) 入口";
		BLUE.."B) 楼梯";
		BLUE.."C) 楼梯";
		GREY.."1) 杰德 (稀有)";
		GREY.."2) 烈焰卫士艾博希尔";
		GREY.."3) 末日扣环之箱";
		GREY..INDENT.."烈焰之父";
		GREY.."4) 古拉鲁克";
		GREY.."5) 大酋长雷德·黑手";
		GREY..INDENT.."盖斯";
		GREY.."6) 奥比";
		GREY.."7) 比斯巨兽";
		GREY.."8) 达基萨斯将军";
		GREY.."9) 黑翼之巢 (团队副本)";
	};
	BlackwingLair = {
		ZoneName = "黑翼之巢";
		Location = "黑石塔";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) 入口";
		BLUE.."B) 通道";
		BLUE.."C) 通道";
		BLUE.."D) 通道";
		GREY.."1) 狂野的拉格佐尔";
		GREY.."2) 坠落的瓦拉斯塔兹";
		GREY.."3) 勒什雷尔";
		GREY.."4) 费尔默";
		GREY.."5) 埃博诺克";
		GREY.."6) 弗莱格尔";
		GREY.."7) 克洛玛古斯";
		GREY.."8) 耐法利安";
	};
	DireMaulEast = {
		ZoneName = "厄运之槌 (东)";
		Location = "菲拉斯";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) 入口";
		BLUE.."B) 入口";
		BLUE.."C) 入口";
		BLUE.."D) 出口";
		GREY.."1) 开始追捕普希林";
		GREY.."2) 结束追捕普希林";
		GREY.."3) 瑟雷姆·刺蹄";
		GREY..INDENT.."海多斯博恩";
		GREY..INDENT.."雷瑟塔帝丝";
		GREY.."4) 埃隆巴克";
		GREY.."5) 奥兹恩";
	};
	DireMaulNorth = {
		ZoneName = "厄运之槌 (北)";
		Location = "菲拉斯";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) 入口";
		GREY.."1) 卫兵摩尔达";
		GREY.."2) 践踏者克雷格";
		GREY.."3) 卫兵芬古斯";
		GREY.."4) 诺特·希姆加可";
		GREY..INDENT.."卫兵斯里基克";
		GREY.."5) 克罗卡斯";
		GREY.."6) 戈多克大王";
		GREY.."7) 厄运之槌 (西)";
	};
	DireMaulWest = {
		ZoneName = "厄运之槌 (西)";
		Location = "菲拉斯";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) 入口";
		BLUE.."B) 水晶塔";
		GREY.."1) 辛德拉古灵";
		GREY.."2) 特迪斯·扭木";
		GREY.."3) 伊琳娜·暗木";
		GREY..INDENT.."卡雷迪斯镇长";
		GREY.."4) 苏斯 (稀有)";
		GREY.."5) 伊莫塔尔";
		GREY.."5) 托塞德林王子";
		GREY.."6) 厄运之槌 (北)";
	};
	Gnomeregan = {
		ZoneName = "诺莫瑞根";
		Location = "丹莫罗";
		LevelRange = "24-33";
		PlayerLimit = "10";
		BLUE.."A) 入口 (正门)";
		BLUE.."B) 入口 (后门)";
		GREY.."1) 粘性辐射尘 (下层)";
		GREY.."2) 格鲁比斯";
		GREY.."3) 矩阵式打孔计算机 3005-B";
		GREY.."4) 清洗区";
		GREY.."5) 电刑器6000型";
		GREY..INDENT.."矩阵式打孔计算机 3005-C";
		GREY.."6) 麦克尼尔·瑟玛普拉格";
		GREY.."7) 黑铁大师 (稀有)";
		GREY.."8) 群体打击者9-60";
		GREY..INDENT.."矩阵式打孔计算机 3005-D";
	};
	Maraudon = {
		ZoneName = "玛拉顿";
		Location = "凄凉之地";
		LevelRange = "40-49";
		PlayerLimit = "10";
		BLUE.."A) 入口 (橙色)";
		BLUE.."B) 入口 (紫色)";
		BLUE.."C) 入口 (传送)";
		GREY.."1) 温格 (第五可汗)";
		GREY.."2) 诺克赛恩";
		GREY.."3) 锐刺鞭笞者";
		GREY.."4) 玛劳杜斯 (第四可汗)";
		GREY.."5) 维利塔恩";
		GREY.."6) 收割者麦什洛克 (稀有)";
		GREY.."7) 被诅咒的塞雷布拉斯";
		GREY.."8) 兰斯利德";
		GREY.."9) 工匠吉兹洛克";
		GREY.."10) 洛特格里普";
		GREY.."11) 瑟莱德丝公主";
	};
	MoltenCore = {
		ZoneName = "熔火之心";
		Location = "黑石深渊";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) 入口";
		GREY.."1) 鲁西弗隆";
		GREY.."2) 玛格曼达";
		GREY.."3) 基赫纳斯";
		GREY.."4) 加尔";
		GREY.."5) 沙斯拉尔";
		GREY.."6) 迦顿男爵";
		GREY.."7) 焚化者古雷曼格";
		GREY.."8) 萨弗隆先驱者";
		GREY.."9) 管理者埃克索图斯";
		GREY.."10) 拉格纳罗斯";
	};
	OnyxiasLair = {
		ZoneName = "奥尼科西亚的巢穴";
		Location = "尘泥沼泽";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) 入口";
		GREY.."1) 奥尼科西亚守卫";
		GREY.."2) 雏龙蛋";
		GREY.."3) 奥尼科西亚";
	};
	RagefireChasm = {
		ZoneName = "怒焰裂谷";
		Location = "奥格瑞玛";
		LevelRange = "13-15";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		GREY.."1) 玛尔·恐怖图腾";
		GREY.."2) 饥饿者塔拉加曼";
		GREY.."3) 祈求者耶戈什";
		GREY.."4) 巴扎兰";
	};
	RazorfenDowns = {
		ZoneName = "剃刀高地";
		Location = "贫瘠之地";
		LevelRange = "35-40";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		GREY.."1) 图特卡什";
		GREY.."2) 亨利·斯特恩";
		GREY..INDENT.."奔尼斯特拉兹";
		GREY.."3) 火眼莫德雷斯";
		GREY.."4) 暴食者";
		GREY.."5) 拉戈斯诺特 (稀有)";
		GREY.."6) 寒冰之王亚门纳尔";
	};
	RazorfenKraul = {
		ZoneName = "剃刀沼泽";
		Location = "贫瘠之地";
		LevelRange = "25-35";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		GREY.."1) 鲁古格";
		GREY.."2) 阿格姆";
		GREY.."3) 亡语者贾格巴";
		GREY.."4) 主宰拉姆塔斯";
		GREY.."5) 暴怒的阿迦赛罗斯";
		GREY.."6) 盲眼猎手 (稀有)";
		GREY.."7) 卡尔加·刺肋";
		GREY.."8) 进口商威利克斯";
		GREY..INDENT.."赫尔拉斯·静水";
		GREY.."9) 唤地者哈穆加 (稀有)";
	};
	ScarletMonastery = {
		ZoneName = "血色修道院";
		Location = "提瑞斯法林地";
		LevelRange = "30-40";
		PlayerLimit = "10";
		BLUE.."A) 入口 (图书馆)";
		BLUE.."B) 入口 (军械库)";
		BLUE.."C) 入口 (大教堂)";
		BLUE.."D) 入口 (墓地)";
		GREY.."1) 驯犬者洛克希";
		GREY.."2) 奥法师杜安";
		GREY.."3) 赫洛德";
		GREY.."4) 大检察官法尔班克斯";
		GREY.."5) 血色十字军指挥官莫格莱尼";
		GREY..INDENT.."大检察官怀特迈恩";
		GREY.."6) 铁脊死灵 (稀有)";
		GREY.."7) 永醒的艾希尔 (稀有)";
		GREY.."8) 死灵勇士 (稀有)";
		GREY.."9) 血法师萨尔诺斯";
	};
	Scholomance = {
		ZoneName = "通灵学院";
		Location = "西瘟疫之地";
		LevelRange = "56-60";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		BLUE.."B) 楼梯";
		BLUE.."C) 楼梯";
		GREY.."1) 基尔图诺斯的卫士";
		GREY..INDENT.."南海镇地契";
		GREY.."2) 传令官基尔图诺斯";
		GREY.."3) 詹迪斯·巴罗夫";
		GREY.."4) 塔伦米尔地契";
		GREY.."5) 血骨傀儡 (下层)";
		GREY.."6) 马杜克·布莱克波尔";
		GREY..INDENT.."维克图斯";
		GREY.."7) 莱斯·霜语";
		GREY..INDENT.."布瑞尔地契";
		GREY.."8) 讲师玛丽希亚";
		GREY.."9) 瑟尔林·卡斯迪诺夫教授";
		GREY.."10) 博学者普克尔特";
		GREY.."11) 拉文尼亚";
		GREY.."12) 阿雷克斯·巴罗夫";
		GREY..INDENT.." 凯尔达隆地契";
		GREY.."13) 伊露希亚·巴罗夫";
		GREY.."14) 黑暗院长加丁";
		GREN.."1') 火炬";
		GREN.."2') 旧宝藏箱";
		GREN.."3') 炼金试验室";
	};
	ShadowfangKeep = {
		ZoneName = "影牙城堡";
		Location = "银松森林";
		LevelRange = "18-25";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		BLUE.."B) 通道";
		BLUE.."C) 通道";
		BLUE..INDENT.."死亡之誓 (稀有)";
		GREY.."1) 亡灵哨兵阿达曼特";
		GREY..INDENT.."巫师阿克鲁比";
		GREY..INDENT.."雷希戈尔";
		GREY.."2) 屠夫拉佐克劳";
		GREY.."3) 席瓦莱恩男爵";
		GREY.."4) 指挥官斯普林瓦尔";
		GREY.."5) 盲眼守卫奥杜";
		GREY.."6) 吞噬者芬鲁斯";
		GREY.."7) 狼王南杜斯";
		GREY.."8) 大法师阿鲁高";
	};
	Stratholme = {
		ZoneName = "斯坦索姆";
		Location = "东瘟疫之地";
		LevelRange = "55-60";
		PlayerLimit = "10";
		BLUE.."A) 入口 (正门)";
		BLUE.."B) 入口 (旁门)";
		GREY.."1) 斯库尔 (稀有, 巡逻)";
		GREY..INDENT.."斯坦索姆信使";
		GREY..INDENT.."弗拉斯·希亚比";
		GREY.."2) 弗雷斯特恩 (稀有, 多个位置)";
		GREY.."3) 不可宽恕者";
		GREY.."4) 悲惨的提米";
		GREY.."5) 炮手威利";
		GREY.."6) 档案管理员加尔福特";
		GREY.."7) 巴纳扎尔";
		GREY.."8) 奥里克斯";
		GREY.."9) 石脊 (稀有)";
		GREY.."10) 安娜丝塔丽男爵夫人";
		GREY.."11) 奈鲁布恩坎";
		GREY.."12) 苍白的玛勒基";
		GREY.."13) 巴瑟拉斯镇长 (多个位置)";
		GREY.."14) 吞咽者拉姆斯登";
		GREY.."15) 瑞文戴尔男爵";
		GREN.."1') 十字军广场邮箱";
		GREN.."2') 市场邮箱";
		GREN.."3') 节日小道的邮箱";
		GREN.."4') 长者广场邮箱";
		GREN.."5') 国王广场邮箱";
		GREN.."6') 弗拉斯·希亚比的邮箱";
	};
	TheDeadmines = {
		ZoneName = "死亡矿井";
		Location = "西部荒野";
		LevelRange = "15-20";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		BLUE.."B) 出口";
		GREY.."1) 拉克佐";
		GREY.."2) 矿工约翰森 (稀有)";
		GREY.."3) 斯尼德";
		GREY.."4) 基尔尼格";
		GREY.."5) 迪菲亚火药";
		GREY.."6) 绿皮队长";
		GREY..INDENT.."曲奇";
		GREY..INDENT.."重拳先生";
		GREY..INDENT.."艾德温·范克利夫";
	};
	TheStockades = {
		ZoneName = "监狱";
		Location = "暴风城";
		LevelRange = "23-26";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		GREY.."1) 可怕的塔格尔 (多个位置)";
		GREY.."2) 卡姆·深怒";
		GREY.."3) 哈姆霍克";
		GREY.."4) 巴吉尔·特雷德";
		GREY.."5) 迪克斯特·瓦德";
		GREY.."6) Bruegal Ironknuckle (稀有)";
	};
	TheSunkenTemple = {
		ZoneName = "阿塔哈卡神庙";
		Location = "悲伤沼泽";
		LevelRange = "44-50";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		BLUE.."B) 楼梯";
		BLUE.."C) 巨魔小首领 (上层)";
		GREY.."1) 哈卡祭坛";
		GREY..INDENT.."阿塔拉利恩";
		GREY.."2) 德姆赛卡尔";
		GREY..INDENT.."德拉维沃尔";
		GREY.."3) 哈卡的化身";
		GREY.."4) 预言者迦玛兰";
		GREY..INDENT.."可悲的奥戈姆";
		GREY.."5) 摩弗拉斯";
		GREY..INDENT.."哈扎斯";
		GREY.."6) 伊兰尼库斯的阴影";
		GREY..INDENT.."精华之泉";
		GREN.."1'-6') 雕像激活顺序";
	};
	Uldaman = {
		ZoneName = "奥达曼";
		Location = "荒芜之地";
		LevelRange = "35-45";
		PlayerLimit = "10";
		BLUE.."A) 入口 (前门)";
		BLUE.."B) 入口 (后门)";
		GREY.."1) 巴尔洛戈";
		GREY.."2) 圣骑士的遗体";
		GREY.."3) 鲁维罗什";
		GREY.."4) 艾隆纳亚";
		GREY.."5) 黑曜石哨兵";
		GREY.."6) 安诺拉 (大师级附魔师)";
		GREY.."7) 古代的石头看守者";
		GREY.."8) 加加恩·火锤";
		GREY.."9) 格瑞姆洛克";
		GREY.."10) 阿扎达斯 (下层)";
		GREY.."11) 诺甘农圆盘 (下层)";
		GREY..INDENT.." 古代宝藏 (下层)";
	};
	WailingCaverns = {
		ZoneName = "哀嚎洞穴";
		Location = "贫瘠之地";
		LevelRange = "15-21";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		GREY.."1) 纳拉雷克斯的信徒";
		GREY.."2) 考布莱恩";
		GREY.."3) 安娜科德拉";
		GREY.."4) 克雷什";
		GREY.."5) 皮萨斯";
		GREY.."6) 斯卡姆";
		GREY.."7) 瑟芬迪斯 (上层)";
		GREY.."8) 永生者沃尔丹 (上层)";
		GREY.."9) 吞噬者穆坦努斯";
		GREY..INDENT.."纳拉雷克斯";
	};
	ZulFarrak = {
		ZoneName = "祖尔法拉克";
		Location = "塔纳利斯";
		LevelRange = "43-47";
		PlayerLimit = "10";
		BLUE.."A) 入口";
		GREY.."1) 安图苏尔";
		GREY.."2) 殉教者塞卡";
		GREY.."3) 巫医祖穆拉恩";
		GREY..INDENT.."祖尔法拉克阵亡英雄";
		GREY.."4) 耐克鲁姆";
		GREY.."5) 布莱中士";
		GREY.."6) 水占师维蕾萨";
		GREY..INDENT.."加兹瑞拉";
		GREY.."7) 乌克兹·沙顶";
		GREY..INDENT.."卢兹鲁";
		GREY.."8) 泽雷利斯 (稀有, 巡逻)";
	};
	ZulGurub = {
		ZoneName = "祖尔格拉布";
		Location = "荆棘谷";
		LevelRange = "60+";
		PlayerLimit = "20";
		BLUE.."A) 入口";
		BLUE.."B) Muddy Churning Waters";
		GREY.."1) 高阶祭祀耶克里克";
		GREY.."2) 高阶祭祀温诺西斯";
		GREY.."3) 高阶祭祀玛尔罗";
		GREY.."4) Bloodlord Mandokir";
		GREY.."5) 疯狂之源";
		GREY..INDENT.."Gri'lek, of the Iron Blood";
		GREY..INDENT.."Hazza'rah, the Dreamweaver";
		GREY..INDENT.."Renataki, of the Thousand Blades";
		GREY..INDENT.."Wushoolay, the Storm Witch";
		GREY.."6) 加兹兰卡";
		GREY.."7) 高阶祭祀塞卡";
		GREY.."8) 高阶祭祀娅尔罗";
		GREY.."9) 妖术师金度";
		GREY.."10) 哈卡";
	}
};



end
