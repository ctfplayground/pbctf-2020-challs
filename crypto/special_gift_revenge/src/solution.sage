from SSS import attack
from Crypto.Util.number import long_to_bytes

N = 123463519828344660835965296108959625188149729700517379543746606603601816029557213728343115758280318474617032830851553509268562367217512005079977122560679743955588214135519642513042848616372204042776892196887455692479457740367547908255044784496969010537283159300508751036032559594474145098337531029291955103059
e = 85803665824396212221464259773478155183477895540333642019501498374139506738444521180470104195883386495607712971252463223185914391456070458788554837326327618859712794129800329295751565279950274474800740076285111503780662397876663144946831503522281710586712396810593754749589799811545251575782431569881989690861
gift = 46710143823773072238724337855139753113453277386728402328859555407710009799097841900723288768522450009531777773692804519189753306306645410280934372812
enc = 106121451638162677594573310940827829041097305506084523508481527070289767121202640647932427882853090304492662258820333412210185673459181060321182621778215705296467924514370932937109363645133019461501960295399876223216991409548390823510949085131028770701612550221001043472702499511394058569487248345808385915190
beta = 0.6
delta = (120 / 1024).n()

print(delta)

def run(m, t):
    _lambda = max(delta, beta - 1/2)

    tmp = 1/12 * m^3 - 13/12 * m + 1/4 * m^2 * t + 1/4 * m * t
    tmp /= 1/2 * m^3 + m^2 + 1/2 * m + 1/2 * t^2 + 1/2 * t + m^2 * t + 1/2 * m * t^2 + 3/2 * m * t

    if _lambda >= tmp:
        print("lambda fail")
        return None

    X = floor(N^delta)
    Y = floor(N^(1/2))

    l0 = floor((e * gift * 2^120 - 1) / N)

    solx, soly = attack(N, l0, e, m, t, X, Y)

    if solx > 0:
        tmp = 1 + (solx + l0) * (N + soly)
        d = int(tmp / e)
        print("private key found:", d)
        return d
    else:
        print("=== no solution was found ===")
        return None

for m in range(5, 12):
    for t in range(1):
        d = run(m, t)
        if d:
            print(long_to_bytes(pow(enc, d, N)))
            exit(0)
