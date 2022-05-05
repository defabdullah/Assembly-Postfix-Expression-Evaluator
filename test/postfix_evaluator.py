texts=[]
results=[]
inp = open("input.txt", "r")
out = open("output.txt", "w")

for x in inp:
    texts.append(x)

def to_hex(num):
    result=""

    for int in range(4):
        rem=num%16
        num=num//16
        if(rem>=10):
            rem=chr(rem+55)
        result=str(rem)+result
    
    return result

def to_dec(num):
    result=0
    dig=len(num)-1
    for i in num:
        if(ord(i)>=65):
            result+=(ord(i)-55)*(16**dig)
        else:
            result+=(ord(i)-48)*(16**dig)
        dig-=1
    return result

for text in texts:
    word_list=text.split()
    length=len(word_list)

    list=[]

    if(length==1):
        results.append(word_list[0])
        continue

    else:
        for i in range(len(word_list)):
            word=word_list[i]
            plus=None
            if 48<=ord(word[0])<=57 or 65<=ord(word[0])<=70 :
                list.append(to_dec(word))
            else:
                if len(list)!=0:
                    first=list.pop()
                    second=list.pop()
                    
                    if word == "+":
                        plus = first + second
                    elif word == "*":
                        plus = first * second
                    elif word == "/":
                        plus = second // first
                    elif word == "&":
                        plus = first & second
                    elif word == "|":
                        plus = first | second
                    elif word == "^":
                        plus = second ^ first

            if plus is not None:
                list.append(plus)

    results.append(to_hex(list.pop()))
out.writelines("%s\n" % l for l in results)
inp.close()
out.close()