"""
Run Collatex on each witness directory.
Pairwise tables for each witness and original
"""

import collatex
import os

witdir = "../witnesses"
outformat = "csv"
collations_out = f"../collations_pairwise/{outformat}"


if not os.path.exists(collations_out):
    os.makedirs(collations_out)

for dname in sorted(os.listdir(witdir)):
    print(f"== {dname}")
    # full path to input dir
    fdname = os.path.join(witdir, dname)
    # output dir per poem
    odname = os.path.join(collations_out, f"{dname}")
    if not os.path.exists(odname):
        os.mkdir(odname)
    # separate poem from witnesses and compare
    #   files2treat is list of tuples
    files2treat = sorted(enumerate(os.listdir(fdname)))
    wits = [fname for fname in files2treat if fname[1] != "poema.txt"]
    assert len(wits) >= 1
    # pair poem with each song and collate
    poem_ffname = os.path.join(fdname, "poema.txt")
    with open(poem_ffname) as pfn:
        poem_txt = pfn.read().strip()
    for wit_tuple in wits:
        wit = wit_tuple[1]
        collation = collatex.Collation()
        ffname = os.path.join(fdname, wit)
        print(" + ", ffname)
        with open(ffname) as wfn:
            wit_id = wit.replace(".txt", "").replace(".xml", "")
            collation.add_plain_witness("poema", poem_txt)
            collation.add_plain_witness(wit_id, wfn.read().strip())
            try:
                alignment_table = collatex.collate(collation,
                                                   output=outformat)
            except Exception as exc:
                print("* Error with [{}]: [{} - Args:{!r}]".format(
                    ffname, type(exc).__name__, exc.args))
                continue
        # individual output files
        witname_out = wit.replace(".txt", "").replace(".xml", "")
        ofname = os.path.join(odname, f"{witname_out}_coll.{outformat}")
        if os.path.exists(ofname) and os.stat(ofname).st_size > 0:
            print(" - Skip", ofname)
            continue
        with open(ofname, mode="w", encoding="utf8") as cfout:
            cfout.write(alignment_table)
