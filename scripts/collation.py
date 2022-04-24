"""
Run Collatex on each witness directory.
Common table for all witnesses
"""

import collatex
import os

witdir = "../witnesses"
outformat = "csv"
collations_out = f"../collation/collations/{outformat}"


if not os.path.exists(collations_out):
    os.makedirs(collations_out)

for dname in sorted(os.listdir(witdir)):
    print(f"== {dname}")
    fdname = os.path.join(witdir, dname)
    collation = collatex.Collation()
    ofname = os.path.join(collations_out, f"{dname}_coll.{outformat}")
    if os.path.exists(ofname) and os.stat(ofname).st_size > 0:
        print(" - Skip", fdname)
        continue
    poem_ffname = os.path.join(fdname, "poema.txt")
    with open(poem_ffname) as poem_fd:
        wid = "poema"
        collation.add_plain_witness(wid, poem_fd.read().strip())
    for idx, fname in sorted(enumerate(os.listdir(fdname))):
        if fname == "poema.txt":
            continue
        ffname = os.path.join(fdname, fname)
        print(" + ", ffname)
        with open(ffname) as wfn:
            # if fname == "poema.txt":
            #     wid = fname.replace(".txt", "")
            # else:
            #     wid = "{}".format(str.zfill(str(idx), 2))
            wid = fname.replace(".txt", "")
            wid = wid.replace(".xml", "")
            collation.add_plain_witness(wid, wfn.read().strip())
    try:
        alignment_table = collatex.collate(collation,
                                           output=outformat)
    except Exception:
        print("* Error with", ffname)
        continue
    #ofname = os.path.join(collations_out, f"{dname}_coll.{outformat}")
    with open(ofname, mode="w", encoding="utf8") as cfout:
        cfout.write(alignment_table)

