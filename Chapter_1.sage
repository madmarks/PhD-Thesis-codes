
import numpy
import random
import timeit


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

    if (p % 6) != 1:
        print('p ≢ 1 (mod 6)\n\n'.format(p))
        return

    if not is_prime(p):
        print('p is NOT prime\n\n'.format(p))
        return

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

    #  5.1. we will use the following dictionary to check validity of common 𝓡(a,p) calculations
    
    Rap_to_a = {}
    a = 1                     # y^2 = x^3 + a
    while len(Rap_to_a) < 6:
        R = Zp(-1)*binom_coeff*(Zp(a)^((p-1)/6))
        #  all 𝓡(a,p) values must be different
        if R not in Rap_to_a:
            Rap_to_a[R] = a
        a += 1

    #  5.2. calculate the least non-negative residues 𝓡(a,p) of congruence 1.7

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
    
    #  5.3. check 𝓡(a,p) validity (all 𝓡(a,p) values must be different)

    for R in Rap_to_a.keys():
        #  check if R is in common R_a_p list
        if R not in R_a_p:
            raise Exception("Invalid 𝓡(a,p) value !!!")

    #  5.4.1. print 𝓡(a,p) values (DEC)
    
    for R, a in Rap_to_a.items():
        print('       𝓡({0:>2},p) = {1:>78}  # DEC'.format(a, Integer(R)))
    print()
    
    #  5.4.2. print 𝓡(a,p) values (HEX)
    
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



###
#
#  Example: find_ec_orders_SEA(p = 2^256 + 2^56 + 2^44 + 1, seed_a = 123456, time_it=False)
#
def find_ec_orders_SEA(p, seed_a, time_it=False, debug=False):
    
    if time_it:
        debug = False

    random.seed(seed_a)
    if debug:
        print(f'Initial seed of random number generator of \'a\' (DEC): {seed_a:>10}\n')

    orders = []
    if not time_it:
        EC = []

    while True:
        a = random.randrange(1,2^30)
        E = EllipticCurve(GF(p),[0,0,0,0,a])

        # https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/ell_finite_field.html#sage.schemes.elliptic_curves.ell_finite_field.EllipticCurve_finite_field.cardinality_pari
        #
        # https://pari.math.u-bordeaux.fr/dochtml/html/Elliptic_curves.html#ellcard
        #
        # https://pari.math.u-bordeaux.fr/dochtml/html/Elliptic_curves.html#se:ellap :
        #
        # Algorithms used. If E/𝔽q has CM by a principal imaginary quadratic order we use a fast explicit formula 
        # (involving essentially Kronecker symbols and Cornacchia's algorithm), in O(log q)^2 bit operations. 
        # Otherwise, we use Shanks-Mestre's baby-step/giant-step method, which runs in time Õ(q^1/4) using Õ(q^1/4) storage, 
        # hence becomes unreasonable when q has about 30 digits. Above this range, the SEA algorithm becomes available, 
        # heuristically in Õ(log q)^4, and primes of the order of 200 digits become feasible. In small characteristic we use 
        # Mestre's (p = 2), Kohel's (p = 3,5,7,13), Satoh-Harley (all in Õ(p^2 n^2)) or Kedlaya's (in Õ(p n^3)) algorithms.
        order = E.cardinality_pari()

        if order not in orders:
            orders.append(order)
            if not time_it:
                EC.append((a, order))

        if len(orders) == 6:
            if not time_it:
                print('The six orders associated with Ɛₚ are:')
                print('          #𝐸ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[0][1]:X}', EC[0][0], ' :  prime' if is_prime(EC[0][1]) else ''))
                print('          #𝐸ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[1][1]:X}', EC[1][0], ' :  prime' if is_prime(EC[1][1]) else ''))
                print('          #𝐸ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[2][1]:X}', EC[2][0], ' :  prime' if is_prime(EC[2][1]) else ''))
                print('          #𝐸ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[3][1]:X}', EC[3][0], ' :  prime' if is_prime(EC[3][1]) else ''))
                print('          #𝐸ₐ,₄ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[4][1]:X}', EC[4][0], ' :  prime' if is_prime(EC[4][1]) else ''))
                print('          #𝐸ₐ,₅ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[5][1]:X}', EC[5][0], ' :  prime' if is_prime(EC[5][1]) else ''))
            
                if debug:
                    print('\nPrint parameters \'a\' and their corresponding Elliptic Curves:\n')
                    print('-' * 9)
                    for i in range(6):
                        ec = EllipticCurve(GF(p),[0,0,0,0,EC[i][0]])
                        print(f' {ec}')                                            # E
                        print('     a = {0:>78}'.format(EC[i][0]))
                        print(' order = {0:>78}  # DEC'.format(EC[i][1]))
                        print(' order = {0:>78}  # HEX'.format(f'0x{EC[i][1]:X}'))
                        print('-' * 9)
            break



def find_ec_orders_BM(p, seed_z, time_it=False, debug=False):

    if time_it:
        debug = False

    Zp = IntegerModRing(p)

    #  1. calculate √-3 (mod p) applying the randomness based approach:

    sqrt_of_minus_3 = 0

    #  initialize PRNG with seed_z (fixed seed allows to create reproducible tests)
    random.seed(seed_z)
    if debug:
        print('/*** sqrt_of_minus_three(...) ***/\n')
        print('{0} p = {1:>78}  # DEC'.format(' '*13, p))             # DEC
        print('{0} p = {1:>78}  # HEX\n'.format(' '*13, f'0x{p:X}'))  # HEX
        print(f'Initial seed (DEC) of random number generator of \'z\': {seed_z:>10}\n')

    while True:
        #  1.1. generate random number z
        z = random.randrange(2, p)
        if debug:
            print('             z  = {0:>78}  # random number       # DEC'.format(z))
            print('             z  = {0:>78}  # random number       # HEX\n'.format(f'0x{z:X}'))

        #  1.2. calculate z' = z^((p-1)/3)
        z_pr = Zp(z)^(Zp(p-1)/Zp(3))                                                  # z' = z^((p-1)/3)
        if debug:
            print('             z\' = {0:>78}  # z\' = z^((p-1)/3)    # DEC'.format(Integer(z_pr)))
            print('             z\' = {0:>78}  # z\' = z^((p-1)/3)    # HEX\n'.format(f'0x{Integer(z_pr):X}'))

        if z_pr != Zp(1):
            # if z' != 1 => z' is cubic non-residue
            sqrt_of_minus_3 = Zp(2*z_pr + 1)                                                      # one of the possible √-3 (mod p)
            if debug:
                print('             /* z is qubic non-residue */\n')
                print('             z  = {0:>78}  # qubic non-residue   # HEX'.format(f'0x{z:X}'))
                print('             z\' = {0:>78}  # z\' = z^((p-1)/3)    # HEX'.format(f'0x{Integer(z_pr):X}'))
                print('    √-3 (mod p) = {0:>78}  # 2(z^((p-1)/3)) + 1  # HEX'.format(f'0x{Integer(sqrt_of_minus_3):X}'))
                print('\n/********************************/\n')
            break

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
    if debug:
        print('              X = {0:>78}  # X from diophantine equation X^2 + 3*(Y^2) = p  # DEC'.format(X))             # DEC
        print('              X = {0:>78}  # X from diophantine equation X^2 + 3*(Y^2) = p  # HEX\n'.format(f'0x{X:X}'))  # HEX
    
    #  2.2. correct sign of X so X ≡ 1 (mod p)

    if X % 3 != 1:
        X = p - X
    if debug:
        print('              X = {0:>78}  # X ≡ 1 (mod p)       # DEC'.format(X))             # DEC
        print('              X = {0:>78}  # X ≡ 1 (mod p)       # HEX\n'.format(f'0x{X:X}'))  # HEX

    #  3. calculate binomial coefficient ((p-1) 2) ((p-1) 6)] (mod p)

    binom_coeff = Zp(2)*Zp(X)
    if debug:
        print('    binom_coeff = {0:>78}  # binomial coefficient ((p-1)/2 (p-1)/6) (mod p) = 2X  # DEC'.format(Integer(binom_coeff)))             # DEC
        print('    binom_coeff = {0:>78}  # binomial coefficient ((p-1)/2 (p-1)/6) (mod p) = 2X  # HEX\n'.format(f'0x{Integer(binom_coeff):X}'))  # HEX

    #  4. calculate multiplier a^((p-1)/6) as ±1, ±ζ, ±(ζ + √-3) where ζ = (-1 - √-3)/2

    zeta_1 = Zp(Zp(Zp(-1) - sqrt_of_minus_3)/Zp(2))
    zeta_2 = Zp(zeta_1 + sqrt_of_minus_3)
    if debug:
        print('             ζ₁ = {0:>78}  # ζ₁ = (-1 - √-3)/2   # DEC'.format(Integer(zeta_1)))             # DEC
        print('             ζ₁ = {0:>78}  # ζ₁ = (-1 - √-3)/2   # HEX\n'.format(f'0x{Integer(zeta_1):X}'))  # HEX

    zeta_2 = Zp(zeta_1 + sqrt_of_minus_3)
    if debug:
        print('             ζ₂ = {0:>78}  # ζ₂ = ζ₁ + √-3       # DEC'.format(Integer(zeta_2)))                 # DEC
        print('             ζ₂ = {0:>78}  # ζ₂ = ζ₁ + √-3       # HEX\n'.format(f'0x{Integer(zeta_2):X}'))      # HEX

    #  5.1. we will use the following dictionary to check validity of common 𝓡(a,p) calculations

    if not time_it:
        random.seed(seed_z)
        if debug:
            print(f'Initial seed of random number generator of \'a\' (DEC): {seed_z:>10}\n')

        Rap_to_a = {}
        while len(Rap_to_a) < 6:
            a = random.randrange(1,2^30)
            R = Zp(-1)*binom_coeff*(Zp(a)^((p-1)/6))
            if R not in Rap_to_a.keys():
                Rap_to_a[R] = a

    #  5.2. calculate the least non-negative residues 𝓡(a,p) of congruence 1.7

    R_a_p = [None] * 6
    R_a_p[0] = Zp(-1)*binom_coeff*Zp(+1)
    R_a_p[1] = Zp(-1)*binom_coeff*Zp(-1)
    R_a_p[2] = Zp(-1)*binom_coeff*Zp(+zeta_1)
    R_a_p[3] = Zp(-1)*binom_coeff*Zp(-zeta_1)
    R_a_p[4] = Zp(-1)*binom_coeff*Zp(+zeta_2)
    R_a_p[5] = Zp(-1)*binom_coeff*Zp(-zeta_2)

    if not time_it:
        if debug:
            print('        𝓡(a,p)₀ = {0:>78}  #    1  # HEX'.format(f'0x{Integer(R_a_p[0]):X}'))    # HEX
            print('        𝓡(a,p)₁ = {0:>78}  #   -1  # HEX'.format(f'0x{Integer(R_a_p[1]):X}'))    # HEX
            print('        𝓡(a,p)₂ = {0:>78}  #   ζ₁  # HEX'.format(f'0x{Integer(R_a_p[2]):X}'))    # HEX
            print('        𝓡(a,p)₃ = {0:>78}  #  -ζ₁  # HEX'.format(f'0x{Integer(R_a_p[3]):X}'))    # HEX
            print('        𝓡(a,p)₄ = {0:>78}  #   ζ₂  # HEX'.format(f'0x{Integer(R_a_p[4]):X}'))    # HEX
            print('        𝓡(a,p)₅ = {0:>78}  #  -ζ₂  # HEX\n'.format(f'0x{Integer(R_a_p[5]):X}'))  # HEX

        #  5.3. check 𝓡(a,p) validity (all 𝓡(a,p) values must be different)

        for R in R_a_p:
            #  check if R is in Rap_to_a keys
            if R not in Rap_to_a.keys():
                raise Exception("Invalid 𝓡(a,p) value !!!")

        if debug:
            for R, a in Rap_to_a.items():
                print('𝓡({0:>10},p) = {1:>78}  # HEX'.format(a, f'0x{Integer(R):X}'))
            print()

    #  6. calculate the six orders #𝐸ₐ,ᵢ associated with Ɛₚ

    E_a = [None] * 6
    for i in range(0,6):
        E_a[i] = Integer(R_a_p[i]) + 1
        if Integer(R_a_p[i]) <= (p//2):
            E_a[i] += p
    if not time_it:
        print('The six orders associated with Ɛₚ are:')
        print('          #𝐸ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{E_a[0]:X}', Rap_to_a[R_a_p[0]], ' :  prime' if is_prime(E_a[0]) else ''))
        print('          #𝐸ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{E_a[1]:X}', Rap_to_a[R_a_p[1]], ' :  prime' if is_prime(E_a[1]) else ''))
        print('          #𝐸ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{E_a[2]:X}', Rap_to_a[R_a_p[2]], ' :  prime' if is_prime(E_a[2]) else ''))
        print('          #𝐸ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{E_a[3]:X}', Rap_to_a[R_a_p[3]], ' :  prime' if is_prime(E_a[3]) else ''))
        print('          #𝐸ₐ,₄ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{E_a[4]:X}', Rap_to_a[R_a_p[4]], ' :  prime' if is_prime(E_a[4]) else ''))
        print('          #𝐸ₐ,₅ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{E_a[5]:X}', Rap_to_a[R_a_p[5]], ' :  prime\n' if is_prime(E_a[5]) else '\n'))



###
#   
#   1. init random number generator with fixed seed
#   2. generate random prime p ≡ 1 (mod 12) to compare worse case
#      (probabilistic approach to find √-3 (mod p))
#   3. generate random a until find all six possible cardinalities
#   4. go to step 1
#
#   Seed must be between 0 and 2^32-1
#   
#   Examples:
#
#       Compare_SEA_and_Our_method(time_it=False)
#
#       Compare_SEA_and_Our_method(seed=23232323, time_it=False)
#
#       Use the following to repeat the results in Section 1.4.3:
#    
#       Compare_SEA_and_Our_method(times=10, p_start=2**256, p_stop=2**257, seed=123456763,  repetitions=5, loops=10, time_it=True)
#
def Compare_SEA_and_Our_method(times=1, p_start=2**256, p_stop=2**257, seed=1234567890, repetitions=3, loops=10, time_it=False, debug=False):

    if p_start < 0 or p_stop < p_start:
        print(f'p_start = {p_start:>79}')
        print(f' p_stop = {p_stop:>79}')
        raise Exception('Error: wrong arguments (p_start or p_stop)!')

    sage.misc.randstate.set_random_seed(seed)
    print(f'\n Initial seed of random number generator of \'p\' (Decimal): {seed:>10}')

    rng_seed_a = numpy.random.RandomState(seed)
    tests_delimiter  = '\n' + 120 * '=' + '\n'

    for i in range(times):
        print(f'\nTest {i+1}:')
        while True:
            global p
            p = sage.misc.prandom.randint(p_start, p_stop)
            #print(f' p = {p:>78X}')

            if (p % 12) != 1:
                #print('p ≢ 1 (mod 12)\n'.format(p))
                continue

            if not is_prime(p):
                #print('p is NOT prime\n'.format(p))
                continue

            if not time_it:
                print('\n{0} p ≡ 1 (mod 12)\n'.format(' ' * 2))
                print('{0} p = {1:>78}  # DEC'.format(' ' * 13, p))
                print('{0} p = {1:>78}  # HEX'.format(' ' * 13, f'0x{p:X}'))

            global seed_a
            seed_a = rng_seed_a.randint(1, 2^32-1)
            print(tests_delimiter)
            if time_it:
                # SEA
                print('find_ec_orders_SEA(p = {0:>68}, seed_a = {1}, time_it = True):\n'.format(f'0x{p:X}', seed_a))
                for _ in range(5):
                    print(sage.misc.sage_timeit.sage_timeit('find_ec_orders_SEA(p, seed_a, True)', globals(), preparse=False, number=loops, repeat=repetitions, precision=2, seconds=True))
                print('\n===\n\n')
                # Our method
                print('find_ec_orders_BM(p = {0:>68}, seed_z = {1}, time_it = True):\n'.format(f'0x{p:X}', seed_a))
                for _ in range(5):
                    print(sage.misc.sage_timeit.sage_timeit("find_ec_orders_BM(p, seed_a, True)", globals(), preparse=False, number=loops, repeat=repetitions, precision=2, seconds=True))
            else:
                print('find_ec_orders_SEA(p = {0:>68}, seed_a = {1}, time_it = False, debug = {2}):\n'.format(f'0x{p:X}', seed_a, debug))
                find_ec_orders_SEA(p, seed_a, False, debug)
                print('\n===\n\n')
                print('find_ec_orders_BM(p = {0:>68}, seed_z = {1}, time_it = False, debug = {2}):\n'.format(f'0x{p:X}', seed_a, debug))
                find_ec_orders_BM(p, seed_a, False, debug)
            print(tests_delimiter)
            break



# Section 1.4.1 Пример с модула на елиптичната крива secp256k1

p = 2^256 - 2^32 - 2^9 - 2^8 - 2^7 - 2^6 - 2^4 - 1  # secp256k1
find_orders(p, factorize_orders=True, debug=False)
print('\n/{0}/\n\n'.format('*'*94))


# Section 1.4.2 Пример с модул просто число, намерено от нас

p = 2^256 + 2^56 + 2^44 + 1                         # prime number found by us
find_orders(p, factorize_orders=True, debug=False)
print('\n/{0}/\n\n'.format('*'*94))


# Section 1.4.3 Сравнение на ефективността спрямо алгоритъма SEA

Compare_SEA_and_Our_method(times=10, p_start=2**256, p_stop=2**257, seed=123456763,  repetitions=5, loops=10, time_it=True)
#Compare_SEA_and_Our_method(times=10, p_start=2**256, p_stop=2**257, seed=123456763,  repetitions=1, loops=1, time_it=False, debug=False)

