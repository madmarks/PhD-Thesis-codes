import numpy
import random
import time
import timeit

from operator import itemgetter


def sqrt_of_minus_one(p,debug=False):
    if debug:
        print('\n/*** sqrt_of_minus_one(...) ***/\n')
        print('{0} p = {1:>78}  # DEC'.format(' '*13, p))             # DEC
        print('{0} p = {1:>78}  # HEX\n'.format(' '*13, f'0x{p:X}'))  # HEX

    Zp = IntegerModRing(p)

    if (p % 8) == 5:           # Note on Representing a Prime as a Sum of Two Squares, John Brillhart, 1972
        res = Zp(2)^((p-1)/4)
        if debug:
            print('    /* deterministic approach: p ≡ 5 (mod 8) */\n')
            print('    √-1 (mod p) = {0:>78}  # one of √-1 (mod p)     # DEC'.format(Integer(res)))              #  √-1 (mod p) DEC
            print('    √-1 (mod p) = {0:>78}  # one of √-1 (mod p)     # HEX\n'.format(f'0x{Integer(res):X}'))   #  √-1 (mod p) HEX
            print('   -√-1 (mod p) = {0:>78}  # the other √-1 (mod p)  # DEC'.format(Integer(-res)))             # -√-1 (mod p) DEC
            print('   -√-1 (mod p) = {0:>78}  # the other √-1 (mod p)  # HEX\n'.format(f'0x{Integer(-res):X}'))  # -√-1 (mod p) HEX
            print('\n/********************************/\n')
        return res
    elif (p % 24) == 17:       # Note on Representing a Prime as a Sum of Two Squares, John Brillhart, 1972
        res = Zp(3)^((p-1)/4)
        if debug:
            print('    /* deterministic approach: p ≡ 17 (mod 24) */\n')
            print('    √-1 (mod p) = {0:>78}  # one of √-1 (mod p)     # DEC'.format(Integer(res)))              #  √-1 (mod p) DEC
            print('    √-1 (mod p) = {0:>78}  # one of √-1 (mod p)     # HEX\n'.format(f'0x{Integer(res):X}'))   #  √-1 (mod p) HEX
            print('   -√-1 (mod p) = {0:>78}  # the other √-1 (mod p)  # DEC'.format(Integer(-res)))             # -√-1 (mod p) DEC
            print('   -√-1 (mod p) = {0:>78}  # the other √-1 (mod p)  # HEX\n'.format(f'0x{Integer(-res):X}'))  # -√-1 (mod p) HEX
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

            #  1.2. calculate z' = z^((p-1)/4)
            z_pr = Zp(z)^((p-1)/4)
            if debug:
                print('             z\' = {0:>78}  # z\' = z^((p-1)/4)       # DEC'.format(Integer(z_pr)))
                print('             z\' = {0:>78}  # z\' = z^((p-1)/4)       # HEX\n'.format(f'0x{Integer(z_pr):X}'))

            # 4|(p-1) so z' = z^((p-1)/4) takes exactly four distinct values - the 4-th roots of unity in Zₚ*: ±1, ±√-1
            if z_pr != Zp(1) and z_pr != Zp(-1):
                res = z_pr                                                      # one of √-1 (mod p)
                if debug:
                    print('             z  = {0:>78}  # random number          # DEC'.format(z))
                    print('             z  = {0:>78}  # random number          # HEX\n'.format(f'0x{z:X}'))

                    print('          /* z\' ≠ ±1 so z\' is ±√-1 */\n')
                    print('             z\' = {0:>78}  # z\' = z^((p-1)/4)       # DEC'.format(Integer(z_pr)))
                    print('             z\' = {0:>78}  # z\' = z^((p-1)/4)       # HEX\n'.format(f'0x{Integer(z_pr):X}'))

                    print('    √-1 (mod p) = {0:>78}  # one of √-1 (mod p)     # DEC'.format(Integer(res)))
                    print('    √-1 (mod p) = {0:>78}  # one of √-1 (mod p)     # HEX\n'.format(f'0x{Integer(res):X}'))
                    print('   -√-1 (mod p) = {0:>78}  # the other √-1 (mod p)  # DEC'.format(Integer(-res)))
                    print('   -√-1 (mod p) = {0:>78}  # the other √-1 (mod p)  # HEX\n'.format(f'0x{Integer(-res):X}'))
                    print('/********************************/\n')
                return res



def find_ec_orders_SEA(p, seed_a, random_a=True, time_it=False, debug=False):

    if time_it:
        debug = False

    random.seed(seed_a)
    if debug:
        print(f'\nInitial seed of random number generator of \'a\' (DEC): {seed_a:>10}\n')

        if (p % 4) != 1:
            raise Exception('p ≢ 1 (mod 4)\n\n'.format(p))

        if not is_prime(p):
            raise Exception('p is NOT prime\n\n'.format(p))

    orders = []
    if not time_it:
        EC = []

    a = 0
    while True:
        if random_a:
            a = random.randrange(1,2^30)      # y² = x³ + ax
        else:
            a += 1                            # y² = x³ + ax

        E = EllipticCurve(GF(p),[0,0,0,a,0])

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

        if len(orders) == 4:
            if time_it:
                return orders
            else:
                EC = sorted(EC,key=itemgetter(0))                                 # sort a list of tuples by 1-st item
                print('\nThe four SORTED orders (DEC) associated with 𝒟ₚ are:\n')
                print('          #𝐷ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(EC[0][0], EC[0][1]))
                print('          #𝐷ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(EC[1][0], EC[1][1]))
                print('          #𝐷ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(EC[2][0], EC[2][1]))
                print('          #𝐷ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10}*x\n'.format(EC[3][0], EC[3][1]))

                print('The four SORTED orders (HEX) associated with 𝒟ₚ are:\n')
                print('          #𝐷ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(f'0x{EC[0][0]:X}', EC[0][1]))
                print('          #𝐷ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(f'0x{EC[1][0]:X}', EC[1][1]))
                print('          #𝐷ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(f'0x{EC[2][0]:X}', EC[2][1]))
                print('          #𝐷ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10}*x\n'.format(f'0x{EC[3][0]:X}', EC[3][1]), flush=True)

                if debug:
                    print('\nPrint parameters \'a\' and their corresponding Elliptic Curves:\n')
                    print('-' * 9)
                    for i in range(4):
                        ec = EllipticCurve(GF(p),[0,0,0,EC[i][1],0])
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
        if (p % 4) != 1:
            raise Exception('p ≢ 1 (mod 4)\n\n'.format(p))

        if not is_prime(p):
            raise Exception('p is NOT prime\n\n'.format(p))

    Zp = IntegerModRing(p)

    #  1. calculate √-1 (mod p)

    sqrt_of_minus_1 = sqrt_of_minus_one(p,debug)  # Zp

    #  2.1. solve the Diophantine equation X² + Y² = p

    sqrt_of_p = sage.misc.functional.isqrt(p)  # Returns an integer square root, i.e., the floor of a square root.

    #  a = b*q + r - dividend equals divisor times quotient plus remainder

    a = p
    b = Integer(sqrt_of_minus_1)
    r = a % b

    while r >= sqrt_of_p:
        a = b
        b = r
        r = a % b

    X = r
    if debug:
        print('              X = {0:>78}  # X from diophantine equation X² + Y² = p  # DEC'.format(X))             # DEC
        print('              X = {0:>78}  # X from diophantine equation X² + Y² = p  # HEX\n'.format(f'0x{X:X}'))  # HEX

    #  2.2. get odd X

    if sage.misc.functional.is_even(X):
        X = sage.misc.functional.isqrt(p - X^2)  # get odd X
    if debug:
        print('              X = {0:>78}  # X is odd, X² + Y² = p  # DEC'.format(X))             # DEC
        print('              X = {0:>78}  # X is odd, X² + Y² = p  # HEX\n'.format(f'0x{X:X}'))  # HEX

    if X % 4 == 3:
        X = -X
    if debug:
        print('              X = {0:>78}  # get negative X         # DEC\n'.format(X))  # DEC

    #  3. calculate binomial coefficient ((p-1)/2 (p-1)/6) (mod p)

    binom_coeff = Zp(2*X)
    if debug:
        print('    binom_coeff = {0:>78}  # binomial coefficient ((p-1)/2 (p-1)/4) (mod p) = 2X  # DEC'.format(Integer(binom_coeff)))             # DEC
        print('    binom_coeff = {0:>78}  # binomial coefficient ((p-1)/2 (p-1)/4) (mod p) = 2X  # HEX\n'.format(f'0x{Integer(binom_coeff):X}'))  # HEX

    #  4.1. we will use the following dictionary to check validity of 𝓡(a,p) calculations

    if not time_it:
        if random_a:
            random.seed(seed_z)
            print(f'Initial seed of random number generator of \'a\' (DEC): {seed_z:>10}\n')

        Rap_to_a = {}
        a = 0
        while len(Rap_to_a) < 4:
            if random_a:
                a = random.randrange(1,2^30)          # y² = x³ + ax
            else:
                a += 1                                # y² = x³ + ax
            R = Zp(-1)*binom_coeff*(Zp(a)^((p-1)/4))
            #  all 𝓡(a,p) values must be different
            if R not in Rap_to_a.keys():
                Rap_to_a[R] = a

    #  4.2. calculate the least non-negative residues 𝓡(a,p) of congruence 2.3
    #       (use multiplier a^((p-1)/4) as ±1 and ±√-1)

    R_a_p = [None] * 4
    R_a_p[0] = Zp(-1)*binom_coeff*Zp(+1)
    R_a_p[1] = Zp(-1)*binom_coeff*Zp(-1)
    R_a_p[2] = Zp(-1)*binom_coeff*(+sqrt_of_minus_1)
    R_a_p[3] = Zp(-1)*binom_coeff*(-sqrt_of_minus_1)

    if debug:
        print('Least non-negative residues 𝓡(a,p), calculated by multipliers ±1, ±√-1:\n')
        print('        𝓡(a,p)₀ = {0:>78}  #  a^((p-1)/4) =    1  # DEC'.format(Integer(R_a_p[0])))             # DEC
        print('        𝓡(a,p)₁ = {0:>78}  #  a^((p-1)/4) =   -1  # DEC'.format(Integer(R_a_p[1])))             # DEC
        print('        𝓡(a,p)₂ = {0:>78}  #  a^((p-1)/4) =  √-1  # DEC'.format(Integer(R_a_p[2])))             # DEC
        print('        𝓡(a,p)₃ = {0:>78}  #  a^((p-1)/4) = -√-1  # DEC\n'.format(Integer(R_a_p[3])))           # DEC

        print('        𝓡(a,p)₀ = {0:>78}  #  a^((p-1)/4) =    1  # HEX'.format(f'0x{Integer(R_a_p[0]):X}'))    # HEX
        print('        𝓡(a,p)₁ = {0:>78}  #  a^((p-1)/4) =   -1  # HEX'.format(f'0x{Integer(R_a_p[1]):X}'))    # HEX
        print('        𝓡(a,p)₂ = {0:>78}  #  a^((p-1)/4) =  √-1  # HEX'.format(f'0x{Integer(R_a_p[2]):X}'))    # HEX
        print('        𝓡(a,p)₃ = {0:>78}  #  a^((p-1)/4) = -√-1  # HEX\n'.format(f'0x{Integer(R_a_p[3]):X}'))  # HEX

        #  4.3. check 𝓡(a,p) validity (all 𝓡(a,p) values must be different)

        for R in Rap_to_a.keys():
            #  check if R is in R_a_p list
            if R not in R_a_p:
                raise Exception("Missing 𝓡(a,p) value !!!")

        #  4.4. print 𝓡(a,p) values

        print('Least non-negative residues 𝓡(a,p) from \'Rap_to_a\' dictionary:\n')
        for R, a in Rap_to_a.items():
            print('𝓡({0:>10},p) = {1:>78}  # DEC'.format(a, Integer(R)))
        print()

        for R, a in Rap_to_a.items():
            print('𝓡({0:>10},p) = {1:>78}  # HEX'.format(a, f'0x{Integer(R):X}'))
        print()

    #  5. calculate the four orders #𝐷ₐ,ᵢ associated with 𝒟ₚ

    Da = [None] * 4
    for i in range(0,4):
        Da[i] = Integer(R_a_p[i]) + 1
        if Integer(R_a_p[i]) <= (p//2):
            Da[i] += p
    if not time_it:
        if debug:
            print('The four orders (DEC) associated with 𝒟ₚ are:\n')
            print('          #𝐷ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(Da[0], Rap_to_a[R_a_p[0]]))
            print('          #𝐷ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(Da[1], Rap_to_a[R_a_p[1]]))
            print('          #𝐷ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(Da[2], Rap_to_a[R_a_p[2]]))
            print('          #𝐷ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10}*x\n'.format(Da[3], Rap_to_a[R_a_p[3]]))

            print('The four orders (HEX) associated with 𝒟ₚ are:\n')
            print('          #𝐷ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(f'0x{Da[0]:X}', Rap_to_a[R_a_p[0]]))
            print('          #𝐷ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(f'0x{Da[1]:X}', Rap_to_a[R_a_p[1]]))
            print('          #𝐷ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(f'0x{Da[2]:X}', Rap_to_a[R_a_p[2]]))
            print('          #𝐷ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10}*x\n'.format(f'0x{Da[3]:X}', Rap_to_a[R_a_p[3]]), flush=True)

        zipped_pairs = zip(Da,R_a_p)                 # The purpose of zip() is to map a similar index of multiple containers
                                                     # so that they can be used just using as a single entity (list of tuples)
        R_a_p = [x for _,x in sorted(zipped_pairs)]
        Da.sort()                                    # sort Da list in place
        print('The four SORTED orders (DEC) associated with 𝒟ₚ are:\n')
        print('          #𝐷ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(Da[0], Rap_to_a[R_a_p[0]]))
        print('          #𝐷ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(Da[1], Rap_to_a[R_a_p[1]]))
        print('          #𝐷ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(Da[2], Rap_to_a[R_a_p[2]]))
        print('          #𝐷ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10}*x\n'.format(Da[3], Rap_to_a[R_a_p[3]]))

        print('The four SORTED orders (HEX) associated with 𝒟ₚ are:\n')
        print('          #𝐷ₐ,₀ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(f'0x{Da[0]:X}', Rap_to_a[R_a_p[0]]))
        print('          #𝐷ₐ,₁ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(f'0x{Da[1]:X}', Rap_to_a[R_a_p[1]]))
        print('          #𝐷ₐ,₂ = {0:>78}  #  y² = x³ + {1:>10}*x'.format(f'0x{Da[2]:X}', Rap_to_a[R_a_p[2]]))
        print('          #𝐷ₐ,₃ = {0:>78}  #  y² = x³ + {1:>10}*x\n'.format(f'0x{Da[3]:X}', Rap_to_a[R_a_p[3]]), flush=True)

        Da_a = [None] * 4
        for i in range(0,4):
            Da_a[i] = (Da[i], Rap_to_a[R_a_p[i]])

    #  6. factorize four orders using the GMP-ECM method

    if factorize_orders:
        Da_factors = [None] * 4
        for i in range(0,4):
            Da_factors[i] = ecm.factor(Da[i])
        if debug:
            print('Prime factors of SORTED orders #𝐷ₐ,ᵢ are:\n')
            print('  #𝐷ₐ,₀ factors = {0:>103}  # DEC'.format(f'{Da_factors[0]}'))
            print('  #𝐷ₐ,₁ factors = {0:>103}  # DEC'.format(f'{Da_factors[1]}'))
            print('  #𝐷ₐ,₂ factors = {0:>103}  # DEC'.format(f'{Da_factors[2]}'))
            print('  #𝐷ₐ,₃ factors = {0:>103}  # DEC\n'.format(f'{Da_factors[3]}'))

            #  7.1 Their HIGHEST prime factors are:

            print(f'HIGHEST prime factors of SORTED orders #𝐷ₐ,ᵢ are:\n')
            print(f'  #𝐷ₐ,₀ highest = {max(Da_factors[0]):>78}  # DEC')
            print(f'  #𝐷ₐ,₁ highest = {max(Da_factors[1]):>78}  # DEC')
            print(f'  #𝐷ₐ,₂ highest = {max(Da_factors[2]):>78}  # DEC')
            print(f'  #𝐷ₐ,₃ highest = {max(Da_factors[3]):>78}  # DEC\n', flush=True)

    if time_it:
        return Da  # orders
    else:
        Da_a = sorted(Da_a,key=itemgetter(0))
        orders = [tpl[0] for tpl in Da_a]
        a      = [tpl[1] for tpl in Da_a]
        return (orders, a)                     # return list of orders and list of corresponding 'a'



###
#   
#   1. init random number generator with fixed seed
#   2. generate random prime p ≡ 1 (mod 4), p ≢ 5 (mod 8) and p ≢ 17 (mod 24)
#      to compare the worse case (probabilistic approach to find √-1 (mod p))
#   3. generate random 'a' until find all four possible cardinalities
#   4. go to step 1
#
#   Seed must be between 0 and 2^32-1
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

            if (p % 4) != 1:
                #print('p ≢ 1 (mod 4)\n'.format(p))
                continue

            if (p % 8) == 5:
                #print('p ≡ 5 (mod 8)\n'.format(p))
                continue

            if (p % 24) == 17:
                #print('p ≡ 17 (mod 24)\n'.format(p))
                continue

            if not is_prime(p):
                #print('p is NOT prime\n'.format(p))
                continue

            if not time_it:
                print('\n{0} p ≡ 1 (mod 4)\n'.format(' ' * 2))
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



# Section 2.4. Пример с модула на елиптичната крива secp224r1 (NIST-224)

p = 2^224 - 2^96 + 1
print('\n# Section 2.4. Пример с модула на елиптичната крива secp224r1 (NIST-224): p = 2^224 - 2^96 + 1\n')
find_ec_orders_BM(p, random_a=False, factorize_orders=True, time_it=False, debug=True)
print('\n/{0}/\n\n'.format('*'*94))


# Пример с модул просто число, намерено от нас

p = 2^256 + 2^56 + 2^44 + 1
print('\n# Пример с модул просто число, намерено от нас: p = 2^256 + 2^56 + 2^44 + 1\n')
find_ec_orders_BM(p, random_a=False, factorize_orders=True, time_it=False, debug=True)
print('\n/{0}/\n\n'.format('*'*94))


# Сравнение на ефективността спрямо алгоритъма SEA

Compare_SEA_and_Our_method(times=10, p_start=2**256, p_stop=2**257, seed=123456763, repetitions=5, loops=10, time_it=True)
#Compare_SEA_and_Our_method(times=10, p_start=2**256, p_stop=2**257, seed=123456763, repetitions=1, loops=1, time_it=False, debug=False)
