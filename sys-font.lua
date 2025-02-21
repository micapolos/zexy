require("font")

sys_font =
  font(
    glyph(" ",
      "    ",
      "    ",
      "    ",
      "    ",
      "    ",
      "    ",
      "    ",
      "    "),

    glyph("!",
      " ",
      "s",
      "s",
      "s",
      "s",
      " ",
      "s",
      " "),

    glyph("@",
      "        ",
      "  ssss  ",
      " s    s ",
      "s  ss  s",
      "s s  s s",
      "s s  s s",
      "s  sss s",
      " s   ss "),

    glyph("#",
      "     ",
      "     ",
      " s s ",
      "sssss",
      " s s ",
      "sssss",
      " s s ",
      "     "),

    glyph("$",
      "    ",
      "  s ",
      " sss",
      "s   ",
      " ss ",
      "   s",
      "sss ",
      "  s "),

    glyph("%",
      "     ",
      "     ",
      "ss  s",
      "ss s ",
      "  s  ",
      " s ss",
      "s  ss",
      "     "),

    glyph("^",
      "     ",
      "  s  ",
      " s s ",
      "s   s",
      "     ",
      "     ",
      "     ",
      "     "),

    glyph("&",
      "     ",
      " s   ",
      "s s  ",
      "s s  ",
      " s   ",
      "s s s",
      "s  s ",
      " ss s"),

    glyph("*",
      "     ",
      "     ",
      " s s ",
      "  s  ",
      "sssss",
      "  s  ",
      " s s ",
      "     "),

    glyph("(",
      "  ",
      " s",
      "s ",
      "s ",
      "s ",
      "s ",
      " s",
      "  "),

    glyph(")",
      "  ",
      "s ",
      " s",
      " s",
      " s",
      " s",
      "s ",
      "  "),

    glyph("_",
      "    ",
      "    ",
      "    ",
      "    ",
      "    ",
      "    ",
      "ssss",
      "    "),

    glyph("-",
      "    ",
      "    ",
      "    ",
      "    ",
      "ssss",
      "    ",
      "    ",
      "    "),

    glyph("+",
      "     ",
      "     ",
      "  s  ",
      "  s  ",
      "sssss",
      "  s  ",
      "  s  ",
      "     "),

    glyph("=",
      "    ",
      "    ",
      "    ",
      "ssss",
      "    ",
      "ssss",
      "    ",
      "    "),

    glyph("[",
      "  ",
      "ss",
      "s ",
      "s ",
      "s ",
      "s ",
      "ss",
      "  "),

    glyph("]",
      "  ",
      "ss",
      " s",
      " s",
      " s",
      " s",
      "ss",
      "  "),

    glyph("{",
      "   ",
      "  s",
      " s ",
      " s ",
      "s  ",
      " s ",
      " s ",
      "  s"),

    glyph("}",
      "   ",
      "s  ",
      " s ",
      " s ",
      "  s",
      " s ",
      " s ",
      "s  "),

    glyph("|",
      " ",
      "s",
      "s",
      "s",
      "s",
      "s",
      "s",
      "s"),

    glyph("\\",
      "   ",
      "s  ",
      "s  ",
      " s ",
      " s ",
      " s ",
      "  s",
      "  s"),

    glyph(":",
      " ",
      " ",
      "s",
      " ",
      " ",
      " ",
      "s",
      " "),

    glyph(";",
      "  ",
      "  ",
      " s",
      "  ",
      "  ",
      " s",
      " s",
      "s "),

    glyph("\"",
      "   ",
      "s s",
      "s s",
      "   ",
      "   ",
      "   ",
      "   ",
      "   "),

    glyph("'",
      " ",
      "s",
      "s",
      " ",
      " ",
      " ",
      " ",
      " "),

    glyph("<",
      "   ",
      "   ",
      "  s",
      " s ",
      "s  ",
      " s ",
      "  s",
      "   "),

    glyph(">",
      "   ",
      "   ",
      "s  ",
      " s ",
      "  s",
      " s ",
      "s  ",
      "   "),

    glyph(",",
      "  ",
      "  ",
      "  ",
      "  ",
      "  ",
      " s",
      " s",
      "s "),

    glyph(".",
      " ",
      " ",
      " ",
      " ",
      " ",
      " ",
      "s",
      " "),

    glyph("/",
      "   ",
      "  s",
      "  s",
      " s ",
      " s ",
      " s ",
      "s  ",
      "s  "),

    glyph("?",
      "    ",
      " ss ",
      "s  s",
      "s  s",
      "  s ",
      "    ",
      "  s ",
      "    "),

    glyph("~",
      "    ",
      " s s",
      "s s ",
      "    ",
      "    ",
      "    ",
      "    ",
      "    "),

    glyph("`",
      "   ",
      "s  ",
      " s ",
      "  s",
      "   ",
      "   ",
      "   ",
      "   "),

    glyph("1",
      "  ",
      " s",
      "ss",
      " s",
      " s",
      " s",
      " s",
      "  "),

    glyph("2",
      "    ",
      "sss ",
      "   s",
      "   s",
      " ss ",
      "s   ",
      "ssss",
      "    "),

    glyph("3",
      "    ",
      "sss ",
      "   s",
      " ss ",
      "   s",
      "   s",
      "sss ",
      "    "),

    glyph("4",
      "    ",
      "  s ",
      " s  ",
      "s s ",
      "ssss",
      "  s ",
      "  s ",
      "    "),

    glyph("5",
      "    ",
      "sss ",
      "s   ",
      "sss ",
      "   s",
      "   s",
      "sss ",
      "    "),

    glyph("6",
      "    ",
      " ss ",
      "s   ",
      "sss ",
      "s  s",
      "s  s",
      " ss ",
      "    "),

    glyph("7",
      "    ",
      "ssss",
      "   s",
      "  s ",
      "  s ",
      " s  ",
      " s  ",
      "    "),

    glyph("8",
      "    ",
      " ss ",
      "s  s",
      " ss ",
      "s  s",
      "s  s",
      " ss ",
      "    "),

    glyph("9",
      "    ",
      " ss ",
      "s  s",
      "s  s",
      " sss",
      "   s",
      " ss ",
      "    "),

    glyph("0",
      "    ",
      " ss ",
      "s  s",
      "s  s",
      "s  s",
      "s  s",
      " ss ",
      "    "),

    glyph("A",
      "    ",
      " ss ",
      "s  s",
      "s  s",
      "ssss",
      "s  s",
      "s  s",
      "    "),

    glyph("B",
      "    ",
      "sss ",
      "s  s",
      "sss ",
      "s  s",
      "s  s",
      "sss ",
      "    "),

    glyph("C",
      "    ",
      " sss",
      "s   ",
      "s   ",
      "s   ",
      "s   ",
      " sss",
      "    "),

    glyph("D",
      "    ",
      "sss ",
      "s  s",
      "s  s",
      "s  s",
      "s  s",
      "sss ",
      "    "),

    glyph("E",
      "    ",
      "ssss",
      "s   ",
      "sss ",
      "s   ",
      "s   ",
      "ssss",
      "    "),

    glyph("F",
      "    ",
      "ssss",
      "s   ",
      "sss ",
      "s   ",
      "s   ",
      "s   ",
      "    "),

    glyph("G",
      "    ",
      " sss",
      "s   ",
      "s ss",
      "s  s",
      "s  s",
      " sss",
      "    "),

    glyph("H",
      "    ",
      "s  s",
      "s  s",
      "ssss",
      "s  s",
      "s  s",
      "s  s",
      "    "),

    glyph("I",
      " ",
      "s",
      "s",
      "s",
      "s",
      "s",
      "s",
      " "),

    glyph("J",
      "  ",
      " s",
      " s",
      " s",
      " s",
      " s",
      "s ",
      "  "),

    glyph("K",
      "    ",
      "s  s",
      "s s ",
      "ss  ",
      "ss  ",
      "s s ",
      "s  s",
      "    "),

    glyph("L",
      "    ",
      "s   ",
      "s   ",
      "s   ",
      "s   ",
      "s   ",
      "ssss",
      "    "),

    glyph("M",
      "     ",
      "s   s",
      "ss ss",
      "s s s",
      "s   s",
      "s   s",
      "s   s",
      "     "),

    glyph("N",
      "    ",
      "s  s",
      "ss s",
      "s ss",
      "s  s",
      "s  s",
      "s  s",
      "    "),

    glyph("O",
      "     ",
      " sss ",
      "s   s",
      "s   s",
      "s   s",
      "s   s",
      " sss ",
      "     "),

    glyph("P",
      "    ",
      "sss ",
      "s  s",
      "s  s",
      "sss ",
      "s   ",
      "s   ",
      "    "),

    glyph("Q",
      "     ",
      " sss ",
      "s   s",
      "s   s",
      "s   s",
      "s   s",
      " sss ",
      "   ss"),

    glyph("R",
      "    ",
      "sss ",
      "s  s",
      "s  s",
      "sss ",
      "s  s",
      "s  s",
      "    "),

    glyph("S",
      "    ",
      " sss",
      "s   ",
      " ss ",
      "   s",
      "   s",
      "sss ",
      "    "),

    glyph("T",
      "     ",
      "sssss",
      "  s  ",
      "  s  ",
      "  s  ",
      "  s  ",
      "  s  ",
      "     "),

    glyph("U",
      "    ",
      "s  s",
      "s  s",
      "s  s",
      "s  s",
      "s  s",
      " ss ",
      "    "),

    glyph("V",
      "     ",
      "s   s",
      "s   s",
      "s   s",
      "s   s",
      " s s ",
      "  s  ",
      "     "),

    glyph("W",
      "     ",
      "s   s",
      "s   s",
      "s   s",
      "s s s",
      "s s s",
      " s s ",
      "     "),

    glyph("X",
      "     ",
      "s   s",
      " s s ",
      "  s  ",
      "  s  ",
      " s s ",
      "s   s",
      "     "),

    glyph("Y",
      "     ",
      "s   s",
      "s   s",
      " s s ",
      "  s  ",
      "  s  ",
      "  s  ",
      "     "),

    glyph("Z",
      "    ",
      "ssss",
      "   s",
      "  s ",
      " s  ",
      "s   ",
      "ssss",
      "    "),

    glyph("a",
      "    ",
      "    ",
      " ss ",
      "   s",
      " sss",
      "s  s",
      " sss",
      "    "),

    glyph("b",
      "    ",
      "s   ",
      "s   ",
      "sss ",
      "s  s",
      "s  s",
      "sss ",
      "    "),

    glyph("c",
      "    ",
      "    ",
      " sss",
      "s   ",
      "s   ",
      "s   ",
      " sss",
      "    "),

    glyph("d",
      "    ",
      "   s",
      "   s",
      " sss",
      "s  s",
      "s  s",
      " sss",
      "    "),

    glyph("e",
      "    ",
      "    ",
      " ss ",
      "s  s",
      "ssss",
      "s   ",
      " ss ",
      "    "),

    glyph("f",
      "  ",
      " s",
      "s ",
      "ss",
      "s ",
      "s ",
      "s ",
      "  "),

    glyph("g",
      "    ",
      "    ",
      " ss ",
      "s  s",
      "s  s",
      " sss",
      "   s",
      " ss "),

    glyph("h",
      "    ",
      "s   ",
      "s   ",
      "sss ",
      "s  s",
      "s  s",
      "s  s",
      "    "),

    glyph("i",
      " ",
      "s",
      " ",
      "s",
      "s",
      "s",
      "s",
      " "),

    glyph("j",
      "  ",
      " s",
      "  ",
      " s",
      " s",
      " s",
      " s",
      "s "),

    glyph("k",
      "    ",
      "s   ",
      "s  s",
      "s s ",
      "ss  ",
      "s s ",
      "s  s",
      "    "),

    glyph("l",
      " ",
      "s",
      "s",
      "s",
      "s",
      "s",
      "s",
      " "),

    glyph("m",
      "       ",
      "       ",
      "ssssss ",
      "s  s  s",
      "s  s  s",
      "s  s  s",
      "s  s  s",
      "       "),

    glyph("n",
      "    ",
      "    ",
      "sss ",
      "s  s",
      "s  s",
      "s  s",
      "s  s",
      "    "),

    glyph("o",
      "    ",
      "    ",
      " ss ",
      "s  s",
      "s  s",
      "s  s",
      " ss ",
      "    "),

    glyph("p",
      "    ",
      "    ",
      "sss ",
      "s  s",
      "s  s",
      "sss ",
      "s   ",
      "s   "),

    glyph("q",
      "    ",
      "    ",
      " sss",
      "s  s",
      "s  s",
      " sss",
      "   s",
      "   s"),

    glyph("r",
      "   ",
      "   ",
      "s s",
      "ss ",
      "s  ",
      "s  ",
      "s  ",
      "   "),

    glyph("s",
      "   ",
      "   ",
      " ss",
      "s  ",
      " s ",
      "  s",
      "ss ",
      "   "),

    glyph("t",
      "  ",
      "s ",
      "ss",
      "s ",
      "s ",
      "s ",
      " s",
      "  "),

    glyph("u",
      "    ",
      "    ",
      "s  s",
      "s  s",
      "s  s",
      "s  s",
      " ss ",
      "    "),

    glyph("v",
      "    ",
      "    ",
      "s  s",
      "s  s",
      "s  s",
      " s s",
      "  s ",
      "    "),

    glyph("w",
      "     ",
      "     ",
      "s   s",
      "s   s",
      "s s s",
      "s s s",
      " s s ",
      "     "),

    glyph("x",
      "     ",
      "     ",
      "s   s",
      " s s ",
      "  s  ",
      " s s ",
      "s   s",
      "     "),

    glyph("y",
      "    ",
      "    ",
      "s  s",
      "s  s",
      "s  s",
      " sss",
      "   s",
      " ss "),

    glyph("z",
      "    ",
      "    ",
      "ssss",
      "  s ",
      " s  ",
      "s   ",
      "ssss",
      "    "),

    glyph(01,
      "                   ",
      " sssssssssssss     ",
      "ss   s s s   ss    ",
      "ss sss s ss sss  s ",
      "ss  sss sss sss sss",
      "ss sss s ss sss  s ",
      "ss   s s ss sss    ",
      " sssssssssssss     ")
    )
