package com.memoryvinyl.data

import com.memoryvinyl.model.Song

object SongLibrary {

    val byCategory: Map<String, List<Song>> = mapOf(
        "蓝色夜晚" to listOf(
            Song(
                songName = "因为爱情",
                artist = "陈奕迅 / 王菲",
                lyricLines = listOf("虽然会经常忘了", "我依然爱着你", "因为爱情", "不会轻易悲伤", "所以一切都是幸福的模样"),
                emotionTags = listOf("安静", "怀旧", "浪漫"),
                reason = "冷色与灯光并存，适合柔和回忆感歌曲。"
            ),
            Song(
                songName = "富士山下",
                artist = "陈奕迅",
                lyricLines = listOf("谁都只得那双手", "靠拥抱亦难任你拥有", "要拥有必先懂失去怎接受", "你还嫌不够"),
                emotionTags = listOf("克制", "夜色", "流动"),
                reason = "透视和留白明显，适合叙事慢歌。"
            ),
            Song(
                songName = "后来",
                artist = "刘若英",
                lyricLines = listOf("后来 我总算学会了如何去爱", "可惜你早已远去", "消失在人海", "有些人 一旦错过就不在"),
                emotionTags = listOf("遗憾", "回望"),
                reason = "画面有旧胶片观感，适合怀旧抒情。"
            )
        ),
        "暖色黄昏" to listOf(
            Song(
                songName = "小半",
                artist = "陈粒",
                lyricLines = listOf("我的爱意有些任性", "你是我穷极一生都做不完的梦", "我在等 风也在等"),
                emotionTags = listOf("黄昏", "温柔"),
                reason = "暖色低饱和适合细碎情绪表达。"
            ),
            Song(
                songName = "稻香",
                artist = "周杰伦",
                lyricLines = listOf("还记得你说家是唯一的城堡", "随着稻香河流继续奔跑", "乡间的歌谣永远的依靠"),
                emotionTags = listOf("治愈", "轻松"),
                reason = "氛围偏治愈，适合抬升幸福感。"
            ),
            Song(
                songName = "平凡之路",
                artist = "朴树",
                lyricLines = listOf("我曾经跨过山和大海", "也穿过人山人海", "我曾经失落失望失掉所有方向"),
                emotionTags = listOf("旅途", "成长"),
                reason = "日落叙事天然匹配旅途感歌词。"
            )
        ),
        "海边日落" to listOf(
            Song(
                songName = "海阔天空",
                artist = "Beyond",
                lyricLines = listOf("原谅我这一生不羁放纵爱自由", "也会怕有一天会跌倒", "背弃了理想 谁人都可以", "哪会怕有一天只你共我"),
                emotionTags = listOf("自由", "海边", "热烈"),
                reason = "海景与开阔地平线让情绪更外放，适合有力量的主歌。"
            ),
            Song(
                songName = "晴天",
                artist = "周杰伦",
                lyricLines = listOf("故事的小黄花", "从出生那年就飘着", "童年的荡秋千", "随记忆一直晃到现在"),
                emotionTags = listOf("青春", "暖色", "轻快"),
                reason = "夕阳带来的暖色调，容易触发青春叙事。"
            ),
            Song(
                songName = "小幸运",
                artist = "田馥甄",
                lyricLines = listOf("与你相遇 好幸运", "但愿在我看不到的天际", "你张开了双翼", "遇见你的注定"),
                emotionTags = listOf("温柔", "治愈", "轻怀旧"),
                reason = "天空和人物的距离感适合细腻又亮一点的旋律。"
            )
        )
    )

    val fallback: List<Song> = listOf(
        Song(
            songName = "夜空中最亮的星",
            artist = "逃跑计划",
            lyricLines = listOf("夜空中最亮的星", "请照亮我前行", "我祈祷拥有一颗透明的心灵"),
            emotionTags = listOf("城市", "夜晚", "希望"),
            reason = "默认情绪分组，保持稳定推荐体验。"
        ),
        Song(
            songName = "慢慢喜欢你",
            artist = "莫文蔚",
            lyricLines = listOf("书里总爱写到喜出望外的傍晚", "我想我会开始想念你", "可是我刚刚才遇见了你"),
            emotionTags = listOf("柔软", "浪漫"),
            reason = "中性画面适合轻抒情。"
        ),
        Song(
            songName = "成都",
            artist = "赵雷",
            lyricLines = listOf("和我在成都的街头走一走", "直到所有的灯都熄灭了也不停留", "你会挽着我的衣袖"),
            emotionTags = listOf("街景", "生活感"),
            reason = "人文和街景通用场景匹配。"
        )
    )
}
