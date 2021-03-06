# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gprof2dot/gprof2dot-0_p20130517.ebuild,v 1.2 2013/06/16 13:29:36 sping Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} )
PYTHON_REQ_USE='xml'

inherit eutils python-r1 python-utils-r1

DESCRIPTION="Converts profiling output to dot graphs"
HOMEPAGE="http://code.google.com/p/jrfonseca/wiki/Gprof2Dot"
SRC_URI="http://www.hartwork.org/public/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-py3-xrange.patch
}

_make_call_script() {
	echo """#! /usr/bin/env python
from gprof2dot import Main
Main().main()
""" > ${ED}$1
	fperms u+x "$1" || die
}

src_install() {
	python_parallel_foreach_impl python_domodule ${PN}.py 

	dodir /usr/bin || die
	_make_call_script /usr/bin/${PN} || die
	python_replicate_script "${ED}"/usr/bin/${PN} || die
}
