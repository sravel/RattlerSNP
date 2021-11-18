#!/usr/bin/env python3
import click
import rattleSNP
from rattleSNP.module import get_install_mode


@click.group(help=click.secho(rattleSNP.description_tools, fg='green', nl=False), context_settings={'help_option_names': ('-h', '--help')})
@click.version_option(rattleSNP.__version__, '--version', '-v')
@click.pass_context
def rattle_cli(ctx):
    pass


# if get_install_mode() == "cluster":
#     rattle_cli.add_command(rattleSNP.run_cluster)
# elif get_install_mode() == "local":
#     rattle_cli.add_command(rattleSNP.run_local)
# else:
#     rattle_cli.add_command(rattleSNP.install_cluster)
#

rattle_cli.add_command(rattleSNP.run_cluster)
rattle_cli.add_command(rattleSNP.runlocal)
rattle_cli.add_command(rattleSNP.edit_tools)
rattle_cli.add_command(rattleSNP.install_cluster)
# rattle_cli.add_command(rattleSNP.update)

def main():
    rattle_cli()

if __name__ == '__main__':
    main()
