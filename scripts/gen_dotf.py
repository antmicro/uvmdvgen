from mako.template import Template
import importlib_resources
from pathlib import Path
import os

def generate_dotf(name: str, bazel_root: str, rootdir: Path, out_dir: Path, link_dependencies=""):
    f_files = []
    for root, _, files in os.walk(rootdir):
        for file in files:
            if file.endswith('.f') and not file.endswith("tb.f"):
                f_files.append(os.path.relpath(str((Path(root) / Path(file))), str(out_dir.parent),
                ))
    # this will actually put them in the correct order, we need to include the agent
    # before env and agent will always be a directory up, starting with a double dot
    f_files = sorted(f_files)
    with open(out_dir, 'w') as fout:
        tpl = Template(filename=str(importlib_resources.files('scripts').parent / "templates" / "bench" / 'tb.f.tpl'))
        fout.write(tpl.render(f_files=f_files,name=name, bazel_root=bazel_root,link_dependencies=link_dependencies))


if __name__ == "__main__":
    generate_dotf(Path("."), Path("test/test.f"))
