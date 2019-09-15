# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit prefix python-any-r1 xdg

DESCRIPTION="Game resources for Freedoom: Phase 1+2"
HOMEPAGE="https://freedoom.github.io"
SRC_URI="https://github.com/freedoom/freedoom/archive/v${PV}.tar.gz -> freedoom-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

BDEPEND="
	$(python_gen_any_dep 'dev-python/pillow[${PYTHON_USEDEP}]')
	app-text/asciidoc
	games-util/deutex
	virtual/imagemagick-tools[png]"

S="${WORKDIR}/freedoom-${PV}"

PATCHES="${FILESDIR}/${P}-Set-DOOMWADPATH.patch"

DOOMWADPATH=share/doom

python_check_deps() {
	has_version -b "dev-python/pillow[${PYTHON_USEDEP}]"
}

src_prepare() {
	# This is to enable usage of the 'PS' coder, which is
	# disabled by default (https://bugs.gentoo.org/664236)
	install -D -t ~/.config/ImageMagick "${FILESDIR}"/ImageMagick/policy.xml || die

	xdg_src_prepare
	eapply_user

	hprefixify dist/freedoom
}

src_compile() {
	emake wads/freedoom{1,2}.wad
}

src_install() {
	emake install-freedoom{1,2} \
		prefix="${ED}/usr/" \
		bindir="bin/" \
		mandir="share/man/" \
		waddir="${DOOMWADPATH}/"
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Freedoom WAD files installed into ${EPREFIX}/usr/${DOOMWADPATH} directory."
}
