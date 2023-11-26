
ace:RegisterFunctions({

-- Match this version to the library version you are pulling from.
version = 1.0,

-- Paste any functions from the AceUtil library that you want to use here.
SplitString = function(s,p,n)
    local l,sp,ep = {},0
    while(sp) do
        sp,ep=strfind(s,p)
        if(sp) then
            tinsert(l,strsub(s,1,sp-1))
            s=strsub(s,ep+1)
        else
            tinsert(l,s)
            break
        end
        if(n) then n=n-1 end
        if(n and (n==0)) then tinsert(l,s) break end
    end
    return unpack(l)
end,
})
