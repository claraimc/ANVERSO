"""Extract Collatex html2 output from notebook"""

import os
import json

nbpath = "collation.ipynb"
outdir = "../collation/collations/html2/files"

outindex = os.path.join(outdir.replace("/files", ""), "index.html")
if not os.path.exists(outdir):
    os.makedirs(outdir)

jo = json.load(open(nbpath))

cells = jo["cells"][0]["outputs"]

with open(outindex, "w") as idxfile:
    idxfile.write("<html><head/><body><div><h3>Collations</h3><ul>\n")
    for idx, cell in enumerate(cells):
        #breakpoint()
        if "name" in cell:
            if cell["name"] == "stdout":
                name_idx = idx
                last_file_line = [ll for ll in cell["text"] if "== " in ll]
                try:
                    last_file_clean = last_file_line[-1].strip().replace("== ", "")
                except IndexError:
                    if idx == len(cells) - 1:
                        print("END")
                        continue
                print(f"- Treating file [{last_file_clean}]")
                if len(last_file_line) > 1:
                    print("  ** More than one filename in cell: {}".format(repr(last_file_line)))
                oname = os.path.join(outdir, last_file_clean + "_coll.html")
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



