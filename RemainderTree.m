ZZ := Integers();
R<k> := PolynomialRing(ZZ);

// Your choice of roots alpha_i.
read alpha, "Your choice of roots alpha_i. Enter integers, separated by a space. e.g. enter 1 2 3 for the list [1,2,3]";
alpha := StringToIntegerSequence(alpha);
alpha;

// Your choice of polynomial here. Note: the alpha_i are not the roots of Q (unless you want it to be boring!)
read Q, "Your choice of polynomial here. Enter integer coefficients, starting from the constant coefficient, separated by a space. e.g. enter 1 0 -1 for 1 - x^2";
Q := Polynomial(StringToIntegerSequence(Q));
Q;

function RemainderTree(Q,alpha)
// Given a polynomial Q and a list alpha of roots (not the roots of the polynomial), evaluate Q at each root efficiently via a remainder tree 
    t := #alpha;
    prod := &*[(k-alpha[i]): i in [1..t]];
    Qbar := Q mod prod;
    if t eq 1 then
        return Qbar;
    end if;
    // Step 0: split Qbar into two factors of t/2 or t+1/2 and t-1/2 each and evaluate Q modulo such polynomials
    prod0 := [];
    s := Ceiling(t/2);
    Append(~prod0,&*[(k-alpha[i]): i in [1..s]]);
    Append(~prod0,&*[(k-alpha[i]): i in [s+1..t]]);
    Ql := Q mod prod0[1];
    Qr := Q mod prod0[2];
    Q := [Ql,Qr];
    Tree := [[Qbar]];
    Append(~Tree,Q);
    first := Ql;
    i := 2;
    // Step 1: Depth first search
    while Degree(first) gt 0 do
        i := i + 1;
        r := Ceiling(s/2);
        prod1 := [];
        Ql := [];
        Qr := [];
        Append(~prod1,&*[(k-alpha[i]): i in [1..r]]);
        Append(~prod1,&*[(k-alpha[i]): i in [r+1..s]]);
        Append(~Ql,Q[1] mod prod1[1]);
        Append(~Ql,Q[1] mod prod1[2]);
        prod2 := [];
        u := t - s;
        v := Ceiling(u/2);
        Append(~prod2,&*[(k-alpha[i]): i in [s+1..s+v]]);
        if s + v + 1 le t then
            Append(~prod2,&*[(k-alpha[i]): i in [s+v+1..t]]);
        else
            Append(~prod2,1);
        end if;
        Append(~Qr,Q[2] mod prod2[1]);
        Append(~Qr,Q[2] mod prod2[2]);
        first := Ql[1];
        Append(~Tree,Append(Append(Ql,Qr[1]),Qr[2]));
        if i ge 4 then
            for j in [1..i] do
                Append(~Tree[i],0);
            end for;
        end if;
        Q := Ql;
        t := s;
        s := r;
    end while;
    
    if (#Tree le 2) or (Degree(Tree[3][3]) lt 1) then
        return Tree;
    end if;
    
    // Step 2: repeat to fill second half of the branches
    t := #alpha;
    s := Ceiling(t/2);
    r := Ceiling(s/2);
    Ql := Tree[3][3];
    Qr := Tree[3][4];
    Q := [Ql,Qr];
    first := Q[1];
    j := 3;
    while Degree(first) gt 0 do
        j := j + 1;
        u := t - s;
        v := Ceiling(u/2);
        w := Ceiling(v/2);
        sold := s;
        s := r;
        r := Ceiling(s/2);
        prod1 := [];
        Ql := [];
        Qr := [];
        Append(~prod1,&*[(k-alpha[i]): i in [sold+1..sold+w]]);
        if v - 1 ge w then
            Append(~prod1,&*[(k-alpha[i]): i in [sold+w+1..sold+v]]);
        else 
            Append(~prod1,1);
        end if;
        Append(~Ql,Q[1] mod prod1[1]);
        Append(~Ql,Q[1] mod prod1[2]);
        prod2 := [];
        Append(~prod2,&*[(k-alpha[i]): i in [sold+v+1..sold+v+w]]);
        if sold+v+w+1 le t then
            Append(~prod2,&*[(k-alpha[i]): i in [sold+v+w+1..t]]);
        else
            Append(~prod2,1);
        end if;
        Append(~Qr,Q[2] mod prod2[1]);
        Append(~Qr,Q[2] mod prod2[2]);
        first := Ql[1];
        Q := [Ql,Qr];
        // Something of a hack, likely won't work beyond a second pass (i.e. if alpha >= 10).
        Tree[j][2^(j-1) + 1] := Ql[1];
        Tree[j][2^(j-1) + 2] := Ql[2];
        Tree[j][2^(j-1) + 3] := Qr[1];
        Tree[j][2^(j-1) + 4] := Qr[2];
        Q := Ql;
        t := s;
        s := r;
    end while;
    return Tree;
end function;

// Untested for #alpha >= 10
RemainderTree(Q,alpha);
