
def sqrt_of_minus_three(p,debug=False):
    if debug:
        print('/*** sqrt_of_minus_three(...) ***/\n')
        print('{0} p = {1:>78}  # DEC'.format(' '*10, p))             # DEC
        print('{0} p = {1:>78}  # HEX\n'.format(' '*10, f'0x{p:X}'))  # HEX

    Zp = IntegerModRing(p)
    
    if (p % 12) == 7:
        res = Zp(-3)^((p+1)/4)
        if debug:
            print('    /* deterministic approach */\n')
            print(' √-3 (mod p) = {0:>78}  # DEC'.format(Integer(res)))           # √-3 (mod p) DEC
            print(' √-3 (mod p) = {0:>78}  # HEX'.format(f'0x{Integer(res):X}'))  # √-3 (mod p) HEX
            print('\n/********************************/\n')
        return res
    else:
        if debug: print('    /* probabilistic approach */\n')
        while True:
            #z = random.randint(2, p-1)                                                   # slower than ZZ.random_element(...)
            z    = ZZ.random_element(2,p,distribution='uniform')
            z_pr = Zp(z)^(Zp(p-1)/Zp(3))                                                  # z' = z^((p-1)/3)
            if debug:
                print('          z  = {0:>78}  # random number       # HEX'.format(f'0x{z:X}'))
                print('          z\' = {0:>78}  # z\' = z^((p-1)/3)    # DEC\n'.format(Integer(z_pr)))
            if z_pr != Zp(1):
                res = Zp(2*z_pr + 1)                                                      # √-3 (mod p)
                if debug:
                    print('          /* z is qubic non-residue */\n')
                    print('          z  = {0:>78}  # qubic non-residue   # HEX'.format(f'0x{z:X}'))
                    print('          z\' = {0:>78}  # z\' = z^((p-1)/3)    # HEX'.format(f'0x{Integer(z_pr):X}'))
                    print(' √-3 (mod p) = {0:>78}  # 2(z^((p-1)/3)) + 1  # HEX'.format(f'0x{Integer(res):X}'))
                    print('\n/********************************/\n')
                return res



def find_orders(p, factorize_orders=False, debug=False):
    Zp = IntegerModRing(p)

    #  1. calculate √-3 (mod p)

    sqrt_of_minus_3 = sqrt_of_minus_three(p,debug)  # Zp

    #  2.1. solve the Diophantine equation X^2 + 3*Y^2 = p

    sqrt_of_p = math.floor(math.sqrt(p))

    #  a = b*q + r - dividend equals divisor times quotient plus remainder

    a = p
    b = Integer(sqrt_of_minus_3)
    r = a % b
    
    while r >= sqrt_of_p:
        a = b
        b = r
        r = a % b

    X = r
    print('             X = {0:>78}  # X from diophantine equation X^2 + 3*(Y^2) == p  # DEC'.format(X))             # DEC
    print('             X = {0:>78}  # X from diophantine equation X^2 + 3*(Y^2) == p  # HEX\n'.format(f'0x{X:X}'))  # HEX
    
    #  2.2. correct sign of X so X ≡ 1 (mod p)

    if X % 3 != 1:
        X = p - X
    print('             X = {0:>78}  # X ≡ 1 (mod p)  # DEC'.format(X))             # DEC
    print('             X = {0:>78}  # X ≡ 1 (mod p)  # HEX\n'.format(f'0x{X:X}'))  # HEX

    #  3. calculate binomial coefficient ((p-1)/2 (p-1)/6) (mod p)

    binom_coeff = Zp(2)*Zp(X)
    print('   binom_coeff = {0:>78}  # binomial coefficient ((p-1)/2 (p-1)/6) (mod p) = 2X  # DEC'.format(Integer(binom_coeff)))             # DEC
    print('   binom_coeff = {0:>78}  # binomial coefficient ((p-1)/2 (p-1)/6) (mod p) = 2X  # HEX\n'.format(f'0x{Integer(binom_coeff):X}'))  # HEX

    #  4. calculate multiplier a^((p-1)/6) as ±1, ±ζ, ±(ζ + √-3) where ζ = (-1 - √-3)/2

    zeta_1 = Zp(Zp(Zp(-1) - sqrt_of_minus_3)/Zp(2))
    zeta_2 = Zp(zeta_1 + sqrt_of_minus_3)
    print('            ζ₁ = {0:>78}  # ζ₁ = (-1 - √-3)/2   # DEC'.format(Integer(zeta_1)))             # DEC
    print('            ζ₁ = {0:>78}  # ζ₁ = (-1 - √-3)/2   # HEX\n'.format(f'0x{Integer(zeta_1):X}'))  # HEX

    zeta_2 = Zp(zeta_1 + sqrt_of_minus_3)
    print('            ζ₂ = {0:>78}  # ζ₂ = ζ₁ + √-3       # DEC'.format(Integer(zeta_2)))                 # DEC
    print('            ζ₂ = {0:>78}  # ζ₂ = ζ₁ + √-3       # HEX\n'.format(f'0x{Integer(zeta_2):X}'))      # HEX

    #  5. calculate the least non-negative residues 𝓡(a,p) of congruence 1.7

    #  5.1 we will use the following dictionary to check validity of common 𝓡(a,p) calculations
    
    Rap_to_a = {}
    a = 1                     # y^2 = x^3 + a
    while len(Rap_to_a) < 6:
        R = Zp(-1)*binom_coeff*(Zp(a)^((p-1)/6))
        #  all 𝓡(a,p) values must be different
        if R not in Rap_to_a:
            Rap_to_a[R] = a
        a += 1

    R_a_p = [None] * 6
    R_a_p[0] = Zp(-1)*binom_coeff*Zp(+1)
    R_a_p[1] = Zp(-1)*binom_coeff*Zp(-1)
    R_a_p[2] = Zp(-1)*binom_coeff*Zp(+zeta_1)
    R_a_p[3] = Zp(-1)*binom_coeff*Zp(-zeta_1)
    R_a_p[4] = Zp(-1)*binom_coeff*Zp(+zeta_2)
    R_a_p[5] = Zp(-1)*binom_coeff*Zp(-zeta_2)
    print('       𝓡(a,p)₀ = {0:>78}  #  a^((p-1)/6) =   1  # DEC'.format(Integer(R_a_p[0])))    # DEC
    print('       𝓡(a,p)₁ = {0:>78}  #  a^((p-1)/6) =  -1  # DEC'.format(Integer(R_a_p[1])))    # DEC
    print('       𝓡(a,p)₂ = {0:>78}  #  a^((p-1)/6) =  ζ₁  # DEC'.format(Integer(R_a_p[2])))    # DEC
    print('       𝓡(a,p)₃ = {0:>78}  #  a^((p-1)/6) = -ζ₁  # DEC'.format(Integer(R_a_p[3])))    # DEC
    print('       𝓡(a,p)₄ = {0:>78}  #  a^((p-1)/6) =  ζ₂  # DEC'.format(Integer(R_a_p[4])))    # DEC
    print('       𝓡(a,p)₅ = {0:>78}  #  a^((p-1)/6) = -ζ₂  # DEC\n'.format(Integer(R_a_p[5])))  # DEC

    print('       𝓡(a,p)₀ = {0:>78}  #  a^((p-1)/6) =   1  # HEX'.format(f'0x{Integer(R_a_p[0]):X}'))    # HEX
    print('       𝓡(a,p)₁ = {0:>78}  #  a^((p-1)/6) =  -1  # HEX'.format(f'0x{Integer(R_a_p[1]):X}'))    # HEX
    print('       𝓡(a,p)₂ = {0:>78}  #  a^((p-1)/6) =  ζ₁  # HEX'.format(f'0x{Integer(R_a_p[2]):X}'))    # HEX
    print('       𝓡(a,p)₃ = {0:>78}  #  a^((p-1)/6) = -ζ₁  # HEX'.format(f'0x{Integer(R_a_p[3]):X}'))    # HEX
    print('       𝓡(a,p)₄ = {0:>78}  #  a^((p-1)/6) =  ζ₂  # HEX'.format(f'0x{Integer(R_a_p[4]):X}'))    # HEX
    print('       𝓡(a,p)₅ = {0:>78}  #  a^((p-1)/6) = -ζ₂  # HEX\n'.format(f'0x{Integer(R_a_p[5]):X}'))  # HEX
    
    #  5.2. check 𝓡(a,p) validity (all 𝓡(a,p) values must be different)

    for R in Rap_to_a.keys():
        #  check if R is in common R_a_p list
        if R not in R_a_p:
            raise Exception("Invalid 𝓡(a,p) value !!!")

    #  5.3.1. print 𝓡(a,p) values (DEC)
    
    for R, a in Rap_to_a.items():
        print('       𝓡({0:>2},p) = {1:>78}  # DEC'.format(a, Integer(R)))
    print()
    
    #  5.3.2. print 𝓡(a,p) values (HEX)
    
    for R, a in Rap_to_a.items():
        print('       𝓡({0:>2},p) = {1:>78}  # HEX'.format(a, f'0x{Integer(R):X}'))
    print()

    #  6. calculate the six orders #𝐸ₐ,ᵢ associated with Ɛₚ

    E_a = [None] * 6
    for i in range(0,6):
        E_a[i] = Integer(R_a_p[i]) + 1
        if Integer(R_a_p[i]) <= (p//2):
            E_a[i] += p

    print('The six orders (DEC) associated with Ɛₚ are:\n')
    print('        # 𝐸ₐ,₀ = {0:>78}  #  a = {1:>2}'.format(E_a[0], Rap_to_a[R_a_p[0]]), ' :  prime' if is_prime(E_a[0]) else '')
    print('        # 𝐸ₐ,₁ = {0:>78}  #  a = {1:>2}'.format(E_a[1], Rap_to_a[R_a_p[1]]), ' :  prime' if is_prime(E_a[1]) else '')
    print('        # 𝐸ₐ,₂ = {0:>78}  #  a = {1:>2}'.format(E_a[2], Rap_to_a[R_a_p[2]]), ' :  prime' if is_prime(E_a[2]) else '')
    print('        # 𝐸ₐ,₃ = {0:>78}  #  a = {1:>2}'.format(E_a[3], Rap_to_a[R_a_p[3]]), ' :  prime' if is_prime(E_a[3]) else '')
    print('        # 𝐸ₐ,₄ = {0:>78}  #  a = {1:>2}'.format(E_a[4], Rap_to_a[R_a_p[4]]), ' :  prime' if is_prime(E_a[4]) else '')
    print('        # 𝐸ₐ,₅ = {0:>78}  #  a = {1:>2}'.format(E_a[5], Rap_to_a[R_a_p[5]]), ' :  prime' if is_prime(E_a[5]) else '')
    print()

    print('The six orders (HEX) associated with Ɛₚ are:\n')
    print('        # 𝐸ₐ,₀ = {0:>78}  #  a = {1:>2}'.format(f'0x{E_a[0]:X}', Rap_to_a[R_a_p[0]]), ' :  prime' if is_prime(E_a[0]) else '')
    print('        # 𝐸ₐ,₁ = {0:>78}  #  a = {1:>2}'.format(f'0x{E_a[1]:X}', Rap_to_a[R_a_p[1]]), ' :  prime' if is_prime(E_a[1]) else '')
    print('        # 𝐸ₐ,₂ = {0:>78}  #  a = {1:>2}'.format(f'0x{E_a[2]:X}', Rap_to_a[R_a_p[2]]), ' :  prime' if is_prime(E_a[2]) else '')
    print('        # 𝐸ₐ,₃ = {0:>78}  #  a = {1:>2}'.format(f'0x{E_a[3]:X}', Rap_to_a[R_a_p[3]]), ' :  prime' if is_prime(E_a[3]) else '')
    print('        # 𝐸ₐ,₄ = {0:>78}  #  a = {1:>2}'.format(f'0x{E_a[4]:X}', Rap_to_a[R_a_p[4]]), ' :  prime' if is_prime(E_a[4]) else '')
    print('        # 𝐸ₐ,₅ = {0:>78}  #  a = {1:>2}'.format(f'0x{E_a[5]:X}', Rap_to_a[R_a_p[5]]), ' :  prime' if is_prime(E_a[5]) else '')
    print()

    #  7. factorize six orders using the GMP-ECM method

    if factorize_orders:
        E_a_factors = [None] * 6
        for i in range(0,6):
            E_a_factors[i] = ecm.factor(E_a[i])
        print()
        print(f'# 𝐸ₐ,₀ factors (DEC) : {E_a_factors[0]}')
        print(f'# 𝐸ₐ,₁ factors (DEC) : {E_a_factors[1]}')
        print(f'# 𝐸ₐ,₂ factors (DEC) : {E_a_factors[2]}')
        print(f'# 𝐸ₐ,₃ factors (DEC) : {E_a_factors[3]}')
        print(f'# 𝐸ₐ,₄ factors (DEC) : {E_a_factors[4]}')
        print(f'# 𝐸ₐ,₅ factors (DEC) : {E_a_factors[5]}\n')

        #  7.1 Their highest prime factors are:

        print(f'# 𝐸ₐ,ᵢ highest prime factors (DEC) are:\n')
        print(f'# 𝐸ₐ,₀ highest = {max(E_a_factors[0]):>78}')
        print(f'# 𝐸ₐ,₁ highest = {max(E_a_factors[1]):>78}')
        print(f'# 𝐸ₐ,₂ highest = {max(E_a_factors[2]):>78}')
        print(f'# 𝐸ₐ,₃ highest = {max(E_a_factors[3]):>78}')
        print(f'# 𝐸ₐ,₄ highest = {max(E_a_factors[4]):>78}')
        print(f'# 𝐸ₐ,₅ highest = {max(E_a_factors[5]):>78}')



p = 2^256 - 2^32 - 2^9 - 2^8 - 2^7 - 2^6 - 2^4 - 1  # secp256k1
find_orders(p, factorize_orders=True, debug=False)
print('\n/{0}/\n\n'.format('*'*94))


p = 2^256 + 2^56 + 2^44 + 1                         # prime number found by us
find_orders(p, factorize_orders=True, debug=False)
print('\n/{0}/\n\n'.format('*'*94))


