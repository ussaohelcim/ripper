from itertools import permutations,chain, product

def bruteforce(charset, maxlength):
    return (''.join(candidate)
        for candidate in chain.from_iterable(product(charset, repeat=i)
        for i in range(1, maxlength + 1)))
				
res = list(bruteforce('xyzw', 4))

floatList = []

with open("all2.txt", "w") as f:
    for v in res:
        txt = "function self."
        if len(v) == 2:
            txt += v +"()"
            txt += "\treturn Vec2("+v[0]+","+v[1]+")\t"
            txt += "end\n"
        elif len(v) == 3:
            txt += v +"()"
            txt += "\treturn Vec3("+v[0]+","+v[1]+","+v[2]+")\t"
            txt += "end\n"
        elif len(v) == 4:
            txt += v +"()"
            txt += "\treturn Vec4("+v[0]+","+v[1]+","+v[2]+","+v[3]+")\t"
            txt += "end\n"
        else:
            txt += v +"()"
            txt += "\treturn Float("+v+")\t"
            txt += "end\n"
        f.write(txt)
    
