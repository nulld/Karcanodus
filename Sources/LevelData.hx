package;

@:enum
abstract BlockType(Int)
{
    var blue1 = 0;
} 



typedef Block = {
    var type:BlockType;
    var x:Int;
    var y:Int;
}

typedef LevelConfig = {
    var blocks:Array<Block>;
}


class LevelData
{
    public static inline var blockWidth = 40;
    public static inline var blockHeight = 20;
    
    
    public static function get(level:Int):LevelConfig
    {
        var result = { blocks : []};
        for (i in 0...10)
            for (j in 0...3)
                result.blocks.push({x : 200 + i * (blockWidth + 2), y : 100 + j * (blockHeight + 2), type : BlockType.blue1});

        return result;
          
    }
}