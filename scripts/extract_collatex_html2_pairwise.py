"""Extract Collatex html2 output from notebook"""

import json
import os
import re


nbpath = "collation_pairwise.ipynb"
outdir = "../collations_pairwise/html2/files"

outindex = os.path.join(outdir.replace("/files", ""), "index.html")
if not os.path.exists(outdir):
    os.makedirs(outdir)

jo = json.load(open(nbpath))

cells = jo["cells"][0]["outputs"]

with open(outindex, "w") as idxfile:
    idxfile.write("<html><head/><body><div><h3>Collations (pairwise)</h3><ul>\n")
    for idx, cell in enumerate(cells):
        #breakpoint()
        if "name" in cell:
            if cell["name"] == "stdout":
                name_idx = idx
                last_song_line = [ll for ll in cell["text"] if "+  ../witnesses" in ll]
                try:
                    # get both the poem and the song names from the witness
                    last_song_clean = re.search(
                        r"/witnesses/(.+?)/(cancion_.+$)", "".join(last_song_line))
                    assert last_song_clean is not None
                    last_poem_str = last_song_clean.group(1)
                    last_song_clean_str = last_song_clean.group(2)
                except IndexError:
                    if idx == len(cells) - 1:
                        print("END")
                        continue
                print(f"- Treating poem [{last_poem_str}]")
                if len(last_song_line) > 1:
                    print("  ~~ More than one song in cell: {}".format(repr(last_song_line)))

                # filename needs to reflect poem + song (pairwise comparison)
                oname = os.path.join(outdir, last_poem_str + "___" +
                                     last_song_clean_str + "_coll.html")

        elif "data" in cell:
            data_idx = idx
            assert data_idx -1 == name_idx
            html = cell["data"]["text/html"]
            with open(oname, "w") as ofn:
                print("  + Writing to [{}]".format(oname))
                # html is list of lines
                ofn.write("".join(html))
            idxfile.write("<li><a target='_blank' href='{}'>{}</a></li>\n".format(
                "./files/{}".format(os.path.split(oname)[1]),
                                    os.path.split(oname)[1]))
    idxfile.write("</ul></div></body></html>\n")



