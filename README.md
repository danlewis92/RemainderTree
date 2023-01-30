# RemainderTree
A MAGMA implementation of a 'remainder tree', for fast polynomial evaluation, in the style of David Harvey's 3rd lecture at PCMI 2022.

Example: Upon loading, RemainderTree.m prompts the user to enter a sequence of space-separated integers, the roots. Pick for example 1 2 3.
The user is then prompted to specify the coefficients of a polynomial, again entered as space-separated integers, constant term first. So an input of 1 2 3 specifies the polynomial 3k^2 + 2k + 1. 
The output is then
[
    [
        3*k^2 + 2*k + 1
    ],
    [
        11*k - 5,
        34
    ],
    [
        6,
        17,
        34,
        0
    ]
]

Reducing 3k^2 + 2k + 1 mod (k-1)(k-2) gives 11k - 5, while reducing modulo (k-3) gives 34. Since 11k - 5 is not constant, a further iteration is needed: 
reducing 11k-5 mod (k-1) we obtain 6, while reducing mod (k-2) gives 17. The leaf 0 is provided as a placeholder.

Thus one concludes that the polynomial 3k^2 + 2k + 1 evaluates to 6, 17 and 34 upon respective inputs 1, 2, 3, as is readily verified.
