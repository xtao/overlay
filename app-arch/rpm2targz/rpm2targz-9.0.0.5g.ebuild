# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm2targz/rpm2targz-9.0.0.5g.ebuild,v 1.1 2012/05/17 05:03:23 vapier Exp $

EAPI="4"

inherit toolchain-funcs eutils

DESCRIPTION="Convert a .rpm file to a .tar.gz archive"
HOMEPAGE="http://www.slackware.com/config/packages.php"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="app-arch/cpio"
DEPEND="app-arch/xz-utils"

src_unpack() {
        unpack ${A}
        cd "${S}"
        sed -i '/^prefix =/s:=.*:= '"${EPREFIX}"'/usr:' Makefile
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	dodoc *.README*
}
