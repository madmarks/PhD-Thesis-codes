import numpy
import random
import time
import timeit

from operator import itemgetter


def sqrt_of_minus_three(p,debug=False):
    if debug:
        print('\n/*** sqrt_of_minus_three(...) ***/\n')
        print('{0} p = {1:>78}  # DEC'.format(' '*13, p))             # DEC
        print('{0} p = {1:>78}  # HEX\n'.format(' '*13, f'0x{p:X}'))  # HEX

    Zp = IntegerModRing(p)

    if (p % 12) == 7:
        res = Zp(-3)^((p+1)/4)
        if debug:
            print('    /* deterministic approach: p ≡ 7 (mod 12)  */\n')
            print('    √-3 (mod p) = {0:>78}  # one of √-3 (mod p)     # DEC'.format(Integer(res)))              #  √-3 (mod p) DEC
            print('    √-3 (mod p) = {0:>78}  # one of √-3 (mod p)     # HEX\n'.format(f'0x{Integer(res):X}'))   #  √-3 (mod p) HEX
            print('   -√-3 (mod p) = {0:>78}  # the other √-3 (mod p)  # DEC'.format(Integer(-res)))             # -√-3 (mod p) DEC
            print('   -√-3 (mod p) = {0:>78}  # the other √-3 (mod p)  # HEX\n'.format(f'0x{Integer(-res):X}'))  # -√-3 (mod p) HEX
            print('\n/********************************/\n')
        return res
    else:
        if debug:
            print('    /* probabilistic approach */\n')
        while True:
            #  1.1. generate random number z
            z    = ZZ.random_element(2, p, distribution='uniform')
            if debug:
                print('             z  = {0:>78}  # random number          # DEC'.format(z))
                print('             z  = {0:>78}  # random number          # HEX\n'.format(f'0x{z:X}'))

            #  1.2. calculate z' = z^((p-1)/3)
            z_pr = Zp(z)^((p-1)/3)
            if debug:
                print('             z\' = {0:>78}  # z\' = z^((p-1)/3)       # DEC'.format(Integer(z_pr)))
                print('             z\' = {0:>78}  # z\' = z^((p-1)/3)       # HEX\n'.format(f'0x{Integer(z_pr):X}'))

            if z_pr != Zp(1):
                res = Zp(2*z_pr + 1)                                                      # one of √-3 (mod p)
                if debug:
                    print('          /* z\' ≠ 1 so z is a qubic non-residue */\n')
                    print('             z  = {0:>78}  # qubic non-residue      # DEC'.format(z))
                    print('             z  = {0:>78}  # qubic non-residue      # HEX\n'.format(f'0x{z:X}'))

                    print('             z\' = {0:>78}  # z\' = z^((p-1)/3)       # DEC'.format(Integer(z_pr)))
                    print('             z\' = {0:>78}  # z\' = z^((p-1)/3)       # HEX\n'.format(f'0x{Integer(z_pr):X}'))

                    print('    √-3 (mod p) = {0:>78}  # 2(z^((p-1)/3)) + 1     # DEC'.format(Integer(res)))
                    print('    √-3 (mod p) = {0:>78}  # 2(z^((p-1)/3)) + 1     # HEX\n'.format(f'0x{Integer(res):X}'))

                    print('   -√-3 (mod p) = {0:>78}  # the other √-3 (mod p)  # DEC'.format(Integer(-res)))
                    print('   -√-3 (mod p) = {0:>78}  # the other √-3 (mod p)  # HEX\n'.format(f'0x{Integer(-res):X}'))
                    print('/********************************/\n')
                return res



###
#
#  Example: find_ec_orders_SEA(p = 2^256 + 2^56 + 2^44 + 1, seed_a = 123456, time_it=False)
#
def find_ec_orders_SEA(p, seed_a, random_a=True, time_it=False, debug=False):

    if time_it:
        debug = False

    random.seed(seed_a)
    if debug:
        print(f'\nInitial seed of random number generator of \'a\' (DEC): {seed_a:>10}\n')

        if (p % 6) != 1:
            raise Exception('p ≢ 1 (mod 6)\n\n'.format(p))

        if not is_prime(p):
            raise Exception('p is NOT prime\n\n'.format(p))

    orders = []
    if not time_it:
        EC = []

    a = 0
    while True:
        if random_a:
            a = random.randrange(1,2^30)      # y² = x³ + a
        else:
            a += 1                            # y² = x³ + a

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
                EC.append((order, a))

        if len(orders) == 6:
            if time_it:
                return orders
            else:
                EC = sorted(EC,key=itemgetter(0))                                 # sort a list of tuples by 1-st item
                print('\nThe six SORTED orders (DEC) associated with Ɛₚ are:\n')
                print('          #𝐸ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(EC[0][0], EC[0][1], ' :  prime' if is_prime(EC[0][0]) else ''))
                print('          #𝐸ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(EC[1][0], EC[1][1], ' :  prime' if is_prime(EC[1][0]) else ''))
                print('          #𝐸ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(EC[2][0], EC[2][1], ' :  prime' if is_prime(EC[2][0]) else ''))
                print('          #𝐸ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(EC[3][0], EC[3][1], ' :  prime' if is_prime(EC[3][0]) else ''))
                print('          #𝐸ₐ,₄ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(EC[4][0], EC[4][1], ' :  prime' if is_prime(EC[4][0]) else ''))
                print('          #𝐸ₐ,₅ = {0:>78}  #  y² = x³ + {1:>10} {2}\n'.format(EC[5][0], EC[5][1], ' :  prime' if is_prime(EC[5][0]) else ''))

                print('The six SORTED orders (HEX) associated with Ɛₚ are:\n')
                print('          #𝐸ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[0][0]:X}', EC[0][1], ' :  prime' if is_prime(EC[0][0]) else ''))
                print('          #𝐸ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[1][0]:X}', EC[1][1], ' :  prime' if is_prime(EC[1][0]) else ''))
                print('          #𝐸ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[2][0]:X}', EC[2][1], ' :  prime' if is_prime(EC[2][0]) else ''))
                print('          #𝐸ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[3][0]:X}', EC[3][1], ' :  prime' if is_prime(EC[3][0]) else ''))
                print('          #𝐸ₐ,₄ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{EC[4][0]:X}', EC[4][1], ' :  prime' if is_prime(EC[4][0]) else ''))
                print('          #𝐸ₐ,₅ = {0:>78}  #  y² = x³ + {1:>10} {2}\n'.format(f'0x{EC[5][0]:X}', EC[5][1], ' :  prime' if is_prime(EC[5][0]) else ''), flush=True)

                if debug:
                    print('\nPrint parameters \'a\' and their corresponding Elliptic Curves:\n')
                    print('-' * 9)
                    for i in range(6):
                        ec = EllipticCurve(GF(p),[0,0,0,0,EC[i][1]])
                        print(f' {ec}')                                            # Elliptic curve
                        print('     a = {0:>78}'.format(EC[i][1]))
                        print(' order = {0:>78}  # DEC'.format(EC[i][0]))
                        print(' order = {0:>78}  # HEX'.format(f'0x{EC[i][0]:X}'))
                        print('-' * 9, flush=True)

                #  return list of orders and list of corresponding 'a'

                orders = [tpl[0] for tpl in EC]
                a      = [tpl[1] for tpl in EC]
                return (orders, a)



def find_ec_orders_BM(p, seed_z=1234567890, random_a=True, factorize_orders=False, time_it=False, debug=False):

    if time_it:
        debug = False

    if debug:
        if (p % 6) != 1:
            raise Exception('p ≢ 1 (mod 6)\n\n'.format(p))

        if not is_prime(p):
            raise Exception('p is NOT prime\n\n'.format(p))

    Zp = IntegerModRing(p)

    #  1. calculate √-3 (mod p)

    sqrt_of_minus_3 = sqrt_of_minus_three(p,debug)  # Zp

    #  2.1. solve the Diophantine equation X² + 3*Y² = p

    sqrt_of_p = sage.misc.functional.isqrt(p)  # Returns an integer square root, i.e., the floor of a square root.

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
        print('              X = {0:>78}  # X from diophantine equation X² + 3*Y² = p  # DEC'.format(X))             # DEC
        print('              X = {0:>78}  # X from diophantine equation X² + 3*Y² = p  # HEX\n'.format(f'0x{X:X}'))  # HEX

    #  2.2. correct sign of X so X ≡ 1 (mod 3)

    if X % 3 != 1:
        X = -X
    if debug:
        print('              X = {0:>78}  # X ≡ 1 (mod 3)       # DEC\n'.format(X))  # DEC

    #  3. calculate binomial coefficient ((p-1)/2 (p-1)/6) (mod p)

    binom_coeff = Zp(2*X)
    if debug:
        print('    binom_coeff = {0:>78}  # binomial coefficient ((p-1)/2 (p-1)/6) (mod p) = 2X  # DEC'.format(Integer(binom_coeff)))             # DEC
        print('    binom_coeff = {0:>78}  # binomial coefficient ((p-1)/2 (p-1)/6) (mod p) = 2X  # HEX\n'.format(f'0x{Integer(binom_coeff):X}'))  # HEX

    #  4. calculate multiplier a^((p-1)/6) as ±1, ±ζ, ±(ζ + √-3) where ζ = (-1 - √-3)/2

    zeta_1 = (Zp(-1) - sqrt_of_minus_3)/Zp(2)
    if debug:
        print('             ζ₁ = {0:>78}  # ζ₁ = (-1 - √-3)/2   # DEC'.format(Integer(zeta_1)))             # DEC
        print('             ζ₁ = {0:>78}  # ζ₁ = (-1 - √-3)/2   # HEX\n'.format(f'0x{Integer(zeta_1):X}'))  # HEX

    zeta_2 = zeta_1 + sqrt_of_minus_3
    if debug:
        print('             ζ₂ = {0:>78}  # ζ₂ = ζ₁ + √-3       # DEC'.format(Integer(zeta_2)))                 # DEC
        print('             ζ₂ = {0:>78}  # ζ₂ = ζ₁ + √-3       # HEX\n'.format(f'0x{Integer(zeta_2):X}'))      # HEX

    #  5.1. we will use the following dictionary to check validity of 𝓡(a,p) calculations

    if not time_it:
        if random_a:
            random.seed(seed_z)
            print(f'Initial seed of random number generator of \'a\' (DEC): {seed_z:>10}\n')

        Rap_to_a = {}
        a = 0
        while len(Rap_to_a) < 6:
            if random_a:
                a = random.randrange(1,2^30)          # y² = x³ + a
            else:
                a += 1                                # y² = x³ + a
            R = Zp(-1)*binom_coeff*(Zp(a)^((p-1)/6))
            #  all 𝓡(a,p) values must be different
            if R not in Rap_to_a.keys():
                Rap_to_a[R] = a

    #  5.2. calculate the least non-negative residues 𝓡(a,p) of congruence 1.7
    #       (use multiplier a^((p-1)/6) as ±1, ±ζ₁ and ±ζ₂, where ζ₁ = (-1 - √-3)/2, ζ₂ = ζ₁ + √-3)

    R_a_p = [None] * 6
    R_a_p[0] = Zp(-1)*binom_coeff*Zp(+1)
    R_a_p[1] = Zp(-1)*binom_coeff*Zp(-1)
    R_a_p[2] = Zp(-1)*binom_coeff*(+zeta_1)
    R_a_p[3] = Zp(-1)*binom_coeff*(-zeta_1)
    R_a_p[4] = Zp(-1)*binom_coeff*(+zeta_2)
    R_a_p[5] = Zp(-1)*binom_coeff*(-zeta_2)
    if debug:
        print('Least non-negative residues 𝓡(a,p), calculated by multipliers ±1, ±ζ, ±(ζ + √-3):\n')
        print('        𝓡(a,p)₀ = {0:>78}  #  a^((p-1)/6) =   1  # DEC'.format(Integer(R_a_p[0])))             # DEC
        print('        𝓡(a,p)₁ = {0:>78}  #  a^((p-1)/6) =  -1  # DEC'.format(Integer(R_a_p[1])))             # DEC
        print('        𝓡(a,p)₂ = {0:>78}  #  a^((p-1)/6) =  ζ₁  # DEC'.format(Integer(R_a_p[2])))             # DEC
        print('        𝓡(a,p)₃ = {0:>78}  #  a^((p-1)/6) = -ζ₁  # DEC'.format(Integer(R_a_p[3])))             # DEC
        print('        𝓡(a,p)₄ = {0:>78}  #  a^((p-1)/6) =  ζ₂  # DEC'.format(Integer(R_a_p[4])))             # DEC
        print('        𝓡(a,p)₅ = {0:>78}  #  a^((p-1)/6) = -ζ₂  # DEC\n'.format(Integer(R_a_p[5])))           # DEC

        print('        𝓡(a,p)₀ = {0:>78}  #  a^((p-1)/6) =   1  # HEX'.format(f'0x{Integer(R_a_p[0]):X}'))    # HEX
        print('        𝓡(a,p)₁ = {0:>78}  #  a^((p-1)/6) =  -1  # HEX'.format(f'0x{Integer(R_a_p[1]):X}'))    # HEX
        print('        𝓡(a,p)₂ = {0:>78}  #  a^((p-1)/6) =  ζ₁  # HEX'.format(f'0x{Integer(R_a_p[2]):X}'))    # HEX
        print('        𝓡(a,p)₃ = {0:>78}  #  a^((p-1)/6) = -ζ₁  # HEX'.format(f'0x{Integer(R_a_p[3]):X}'))    # HEX
        print('        𝓡(a,p)₄ = {0:>78}  #  a^((p-1)/6) =  ζ₂  # HEX'.format(f'0x{Integer(R_a_p[4]):X}'))    # HEX
        print('        𝓡(a,p)₅ = {0:>78}  #  a^((p-1)/6) = -ζ₂  # HEX\n'.format(f'0x{Integer(R_a_p[5]):X}'))  # HEX

        #  5.3. check 𝓡(a,p) validity (all 𝓡(a,p) values must be different)

        for R in Rap_to_a.keys():
            #  check if R is in R_a_p list
            if R not in R_a_p:
                raise Exception("Missing 𝓡(a,p) value !!!")

        #  5.4. print 𝓡(a,p) values

        print('Least non-negative residues 𝓡(a,p) from \'Rap_to_a\' dictionary:\n')
        for R, a in Rap_to_a.items():
            print('𝓡({0:>10},p) = {1:>78}  # DEC'.format(a, Integer(R)))
        print()

        for R, a in Rap_to_a.items():
            print('𝓡({0:>10},p) = {1:>78}  # HEX'.format(a, f'0x{Integer(R):X}'))
        print()

    #  6. calculate the six orders #𝐸ₐ,ᵢ associated with Ɛₚ

    Ea = [None] * 6
    for i in range(0,6):
        Ea[i] = Integer(R_a_p[i]) + 1
        if Integer(R_a_p[i]) <= (p//2):
            Ea[i] += p
    if not time_it:
        if debug:
            print('The six orders (DEC) associated with Ɛₚ are:\n')
            print('          #𝐸ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[0], Rap_to_a[R_a_p[0]], ' :  prime' if is_prime(Ea[0]) else ''))
            print('          #𝐸ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[1], Rap_to_a[R_a_p[1]], ' :  prime' if is_prime(Ea[1]) else ''))
            print('          #𝐸ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[2], Rap_to_a[R_a_p[2]], ' :  prime' if is_prime(Ea[2]) else ''))
            print('          #𝐸ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[3], Rap_to_a[R_a_p[3]], ' :  prime' if is_prime(Ea[3]) else ''))
            print('          #𝐸ₐ,₄ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[4], Rap_to_a[R_a_p[4]], ' :  prime' if is_prime(Ea[4]) else ''))
            print('          #𝐸ₐ,₅ = {0:>78}  #  y² = x³ + {1:>10} {2}\n'.format(Ea[5], Rap_to_a[R_a_p[5]], ' :  prime' if is_prime(Ea[5]) else ''))

            print('The six orders (HEX) associated with Ɛₚ are:\n')
            print('          #𝐸ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[0]:X}', Rap_to_a[R_a_p[0]], ' :  prime' if is_prime(Ea[0]) else ''))
            print('          #𝐸ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[1]:X}', Rap_to_a[R_a_p[1]], ' :  prime' if is_prime(Ea[1]) else ''))
            print('          #𝐸ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[2]:X}', Rap_to_a[R_a_p[2]], ' :  prime' if is_prime(Ea[2]) else ''))
            print('          #𝐸ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[3]:X}', Rap_to_a[R_a_p[3]], ' :  prime' if is_prime(Ea[3]) else ''))
            print('          #𝐸ₐ,₄ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[4]:X}', Rap_to_a[R_a_p[4]], ' :  prime' if is_prime(Ea[4]) else ''))
            print('          #𝐸ₐ,₅ = {0:>78}  #  y² = x³ + {1:>10} {2}\n'.format(f'0x{Ea[5]:X}', Rap_to_a[R_a_p[5]], ' :  prime' if is_prime(Ea[5]) else ''), flush=True)

        zipped_pairs = zip(Ea,R_a_p)                 # The purpose of zip() is to map a similar index of multiple containers
                                                     # so that they can be used just using as a single entity (list of tuples)
        R_a_p = [x for _,x in sorted(zipped_pairs)]
        Ea.sort()                                    # sort Ea list in place
        print('The six SORTED orders (DEC) associated with Ɛₚ are:\n')
        print('          #𝐸ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[0], Rap_to_a[R_a_p[0]], ' :  prime' if is_prime(Ea[0]) else ''))
        print('          #𝐸ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[1], Rap_to_a[R_a_p[1]], ' :  prime' if is_prime(Ea[1]) else ''))
        print('          #𝐸ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[2], Rap_to_a[R_a_p[2]], ' :  prime' if is_prime(Ea[2]) else ''))
        print('          #𝐸ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[3], Rap_to_a[R_a_p[3]], ' :  prime' if is_prime(Ea[3]) else ''))
        print('          #𝐸ₐ,₄ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(Ea[4], Rap_to_a[R_a_p[4]], ' :  prime' if is_prime(Ea[4]) else ''))
        print('          #𝐸ₐ,₅ = {0:>78}  #  y² = x³ + {1:>10} {2}\n'.format(Ea[5], Rap_to_a[R_a_p[5]], ' :  prime' if is_prime(Ea[5]) else ''))

        print('The six SORTED orders (HEX) associated with Ɛₚ are:\n')
        print('          #𝐸ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[0]:X}', Rap_to_a[R_a_p[0]], ' :  prime' if is_prime(Ea[0]) else ''))
        print('          #𝐸ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[1]:X}', Rap_to_a[R_a_p[1]], ' :  prime' if is_prime(Ea[1]) else ''))
        print('          #𝐸ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[2]:X}', Rap_to_a[R_a_p[2]], ' :  prime' if is_prime(Ea[2]) else ''))
        print('          #𝐸ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[3]:X}', Rap_to_a[R_a_p[3]], ' :  prime' if is_prime(Ea[3]) else ''))
        print('          #𝐸ₐ,₄ = {0:>78}  #  y² = x³ + {1:>10} {2}'.format(f'0x{Ea[4]:X}', Rap_to_a[R_a_p[4]], ' :  prime' if is_prime(Ea[4]) else ''))
        print('          #𝐸ₐ,₅ = {0:>78}  #  y² = x³ + {1:>10} {2}\n'.format(f'0x{Ea[5]:X}', Rap_to_a[R_a_p[5]], ' :  prime' if is_prime(Ea[5]) else ''), flush=True)

        Ea_a = [None] * 6
        for i in range(0,6):
            Ea_a[i] = (Ea[i], Rap_to_a[R_a_p[i]])

    #  7. factorize six orders using the GMP-ECM method

    if factorize_orders:
        Ea_factors = [None] * 6
        for i in range(0,6):
            Ea_factors[i] = ecm.factor(Ea[i])
        if debug:
            print('Prime factors of SORTED orders #𝐸ₐ,ᵢ are:\n')
            print('  #𝐸ₐ,₀ factors = {0:>100}  # DEC'.format(f'{Ea_factors[0]}'))
            print('  #𝐸ₐ,₁ factors = {0:>100}  # DEC'.format(f'{Ea_factors[1]}'))
            print('  #𝐸ₐ,₂ factors = {0:>100}  # DEC'.format(f'{Ea_factors[2]}'))
            print('  #𝐸ₐ,₃ factors = {0:>100}  # DEC'.format(f'{Ea_factors[3]}'))
            print('  #𝐸ₐ,₄ factors = {0:>100}  # DEC'.format(f'{Ea_factors[4]}'))
            print('  #𝐸ₐ,₅ factors = {0:>100}  # DEC\n'.format(f'{Ea_factors[5]}'))

            #  7.1 Their HIGHEST prime factors are:

            print(f'HIGHEST prime factors of SORTED orders #𝐸ₐ,ᵢ are:\n')
            print(f'  #𝐸ₐ,₀ highest = {max(Ea_factors[0]):>78}  # DEC')
            print(f'  #𝐸ₐ,₁ highest = {max(Ea_factors[1]):>78}  # DEC')
            print(f'  #𝐸ₐ,₂ highest = {max(Ea_factors[2]):>78}  # DEC')
            print(f'  #𝐸ₐ,₃ highest = {max(Ea_factors[3]):>78}  # DEC')
            print(f'  #𝐸ₐ,₄ highest = {max(Ea_factors[4]):>78}  # DEC')
            print(f'  #𝐸ₐ,₅ highest = {max(Ea_factors[5]):>78}  # DEC\n', flush=True)

    if time_it:
        return Ea  # orders
    else:
        Ea_a = sorted(Ea_a,key=itemgetter(0))
        orders = [tpl[0] for tpl in Ea_a]
        a      = [tpl[1] for tpl in Ea_a]
        return (orders, a)                     # return list of orders and list of corresponding 'a'



###
#   
#   1. init random number generator with fixed seed
#   2. generate random prime p ≡ 1 (mod 6), p ≢ 7 (mod 12) to compare 
#      the worse case (probabilistic approach to find √-3 (mod p))
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
#       Compare_SEA_and_Our_method(times=10, p_start=2**256, p_stop=2**257, seed=123456763, repetitions=5, loops=10, time_it=True)
#
def Compare_SEA_and_Our_method(times=1, p_start=2**256, p_stop=2**257, seed=1234567890, random_a=True, repetitions=3, loops=10, time_it=False, debug=False):

    if p_start < 0 or p_stop < p_start:
        print(f'p_start = {p_start:>79}')
        print(f' p_stop = {p_stop:>79}')
        raise Exception('Error: wrong arguments (p_start or p_stop)!')

    sage.misc.randstate.set_random_seed(seed)
    print(f'\nInitial seed of random number generator of \'p\' (Decimal): {seed:>10}')

    rng_seed_a = numpy.random.RandomState(seed)
    tests_delimiter  = '\n' + 128 * '=' + '\n'

    for i in range(times):
        print(f'\nTest {i+1}:')
        while True:
            global p
            p = sage.misc.prandom.randint(p_start, p_stop)
            #print(f' p = {p:>78X}')

            if (p % 6) != 1:
                #print('p ≢ 1 (mod 6)\n'.format(p))
                continue

            if (p % 12) == 7:
                #print('p ≡ 7 (mod 12)\n'.format(p))
                continue
                
            if not is_prime(p):
                #print('p is NOT prime\n'.format(p))
                continue

            if not time_it:
                print('\n{0} p ≡ 1 (mod 6)\n'.format(' ' * 2))
                print('{0} p = {1:>78}  # DEC'.format(' ' * 13, p))
                print('{0} p = {1:>78}  # HEX'.format(' ' * 13, f'0x{p:X}'))

            global seed_a
            seed_a = rng_seed_a.randint(1, 2^32-1)
            print(tests_delimiter)
            if time_it:
                units   = [u"s", u"ms", u"μs", u"ns"]
                scaling = [1, 1e3, 1e6, 1e9]
                order   =  1

                # SEA
                #start = time.time()
                print('find_ec_orders_SEA(p = {0:>68}, seed_a = {1}, random_a = True, time_it = True):\n'.format(f'0x{p:X}', seed_a))
                precision = int(6)
                best_SEA = sage.misc.sage_timeit.sage_timeit(
                    'find_ec_orders_SEA(p, seed_a, random_a=True, time_it=True)',
                    globals(),
                    preparse=False,
                    number=loops,
                    repeat=repetitions,
                    precision=precision,
                    seconds=True
                )
                stats = (loops, repetitions, precision, best_SEA * scaling[order], units[order]) # use scaling because 'best_SEA' is in seconds
                print(sage.misc.sage_timeit.SageTimeitResult(stats))
                #end = time.time()
                #print('\nExecution time of test: {0} seconds'.format(end - start))
                print('\n-----\n\n', flush=True)

                # Our method
                print('find_ec_orders_BM(p = {0:>68}, seed_z = {1}, random_a = True, time_it = True):\n'.format(f'0x{p:X}', seed_a))
                precision = int(4)
                best_BM = sage.misc.sage_timeit.sage_timeit(
                    'find_ec_orders_BM(p, seed_a, random_a=True, time_it=True)',
                    globals(),
                    preparse=False,
                    number=loops,
                    repeat=repetitions,
                    precision=precision,
                    seconds=True
                )
                stats = (loops, repetitions, precision, best_BM * scaling[order], units[order]) # use scaling because 'best_BM' is in seconds
                print(sage.misc.sage_timeit.SageTimeitResult(stats), flush=True)

                print('\n-----\n\n')
                print('SEA is around {0} times slower'.format(math.floor(best_SEA//best_BM)))
            else:
                print('find_ec_orders_SEA(p = {0:>68}, seed_a = {1}, random_a = {2}, time_it = False, debug = {3}):\n'.format(f'0x{p:X}', seed_a, random_a, debug))
                orders_SEA, a_SEA = find_ec_orders_SEA(p, seed_a, random_a=random_a, time_it=False, debug=debug)
                print('\n===\n\n')

                print('find_ec_orders_BM(p = {0:>68}, seed_z = {1}, random_a = {2}, time_it = False, debug = {3}):\n'.format(f'0x{p:X}', seed_a, random_a, debug))
                orders_BM, a_BM = find_ec_orders_BM(p, seed_a, random_a=random_a, time_it=False, debug=debug)

                if orders_SEA != orders_BM:
                    print(f'orders_SEA = {orders_SEA}\n')
                    print(f' orders_BM = {orders_BM}\n')
                    raise Exception("Not matching orders between the SEA and BM methods!!!")

                if a_SEA != a_BM:
                    print(f'     a_SEA = {a_SEA}\n')
                    print(f'      a_BM = {a_BM}\n')
                    raise Exception("Not matching a\'s between the SEA and BM methods!!!")
            print(tests_delimiter, flush=True)
            break



# Section 1.4.1 Пример с модула на елиптичната крива secp256k1

p = 2^256 - 2^32 - 2^9 - 2^8 - 2^7 - 2^6 - 2^4 - 1                                       # secp256k1
print('\n# Section 1.4.1 Пример с модула на елиптичната крива secp256k1\n')
find_ec_orders_BM(p, random_a=False, factorize_orders=True, time_it=False, debug=True)
print('/{0}/\n\n'.format('*'*94))


# Section 1.4.2 Пример с модул просто число, намерено от нас

p = 2^256 + 2^56 + 2^44 + 1
print('\n# Section 1.4.2 Пример с модул просто число, намерено от нас\n')
find_ec_orders_BM(p, random_a=False, factorize_orders=False, time_it=False, debug=True)
print('/{0}/\n\n'.format('*'*94))


# Сравнение на резултатите за редовете на 10 фамилии елиптични криви 
# (различни p, p ≡ 1 (mod 6)) спрямо получените чрез алгоритъма SEA

print('\n# Сравнение на резултатите за редовете на 10 фамилии елиптични криви (различни p, p ≡ 1 (mod 6)) спрямо получените чрез алгоритъма SEA\n')
Compare_SEA_and_Our_method(times=10, p_start=2**256, p_stop=2**257, seed=123456763, random_a=True, repetitions= 1, loops=1, time_it=False, debug=False)


# Сравнение на резултата за редовете на 1-на фамилия елиптични криви спрямо 
# алгоритъма SEA (сиида е подбран така, че във фамилията криви да има прост ред)

print('\n# Сравнение на резултата за редовете на 1 фамилия елиптични криви спрямо алгоритъма SEA (сиида е подбран така, че във фамилията криви да има прост ред)\n')
Compare_SEA_and_Our_method(times=1, p_start=2**256, p_stop=2**257, seed=183, random_a=True, repetitions=1, loops=1, time_it=False, debug=False)


# Section 1.4.3 Сравнение на ефективността спрямо алгоритъма SEA

print('\n# Section 1.4.3 Сравнение на ефективността спрямо алгоритъма SEA\n')
Compare_SEA_and_Our_method(times=10, p_start=2**256, p_stop=2**257, seed=123456763, random_a=True, repetitions=10, loops=3, time_it=True, debug=False)
