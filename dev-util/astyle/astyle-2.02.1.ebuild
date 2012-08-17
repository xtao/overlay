# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/astyle/astyle-2.02.1.ebuild,v 1.5 2012/07/29 16:56:41 armin76 Exp $

EAPI=4

inherit eutils java-pkg-opt-2 multilib toolchain-funcs

DESCRIPTION="Artistic Style is a reindenter and reformatter of C++, C and Java source code"
HOMEPAGE="http://astyle.sourceforge.net/"
SRC_URI="mirror://sourceforge/astyle/astyle_${PV}_linux.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

IUSE="doc java static-libs"

DEPEND="app-arch/xz-utils
	java? ( >=virtual/jdk-1.6 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	tc-export CXX
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build_system.patch
	java-pkg-opt-2_src_prepare
	sed	-e "s:^\(JAVAINCS\s*\)=.*$:\1= $(java-pkg_get-jni-cflags):" \
		-e "s:ar crs:$(tc-getAR) crs:" \
		-e "s:\.so:.dynlib:" \
		-e "s:-dynamiclib -install_name lib${PN}.0.0.0.dynlib:-dynamiclib -Wl,-search_paths_first -L${EROOT}/usr/lib -L${EROOT}/lib -L${EROOT}/tmp/usr/lib -install_name ${EROOT%/}/usr/$(get_libdir)/lib${PN}.0.dynlib:" \
		-e "s:-dynamiclib -install_name lib${PN}j.0.0.0.dynlib:-dynamiclib -Wl,-search_paths_first -L${EROOT}/usr/lib -L${EROOT}/lib -L${EROOT}/tmp/usr/lib -install_name ${EROOT%/}/usr/$(get_libdir)/lib${PN}j.0.dynlib:" \
		-i build/gcc/Makefile || die
}

src_compile() {
	local mk_opts="-f ../build/gcc/Makefile -C src"
	emake ${mk_opts} ${PN}
	emake ${mk_opts} shared
	if use java ; then
		emake ${mk_opts} java
	fi
	if use static-libs ; then
		emake ${mk_opts} static
	fi
}

src_install() {
	insinto /usr/include
	doins src/${PN}.h

	pushd src/bin &> /dev/null
	dobin ${PN}
	popd &> /dev/null

	mkdir ${ED}/usr/$(get_libdir)
	cd src/bin
	cp lib${PN}.0.0.0.dynlib ${ED}/usr/$(get_libdir)/lib${PN}.0.0.0.dynlib
	dosym lib${PN}.0.0.0.dynlib /usr/$(get_libdir)/lib${PN}.0.dynlib
	dosym lib${PN}.0.0.0.dynlib /usr/$(get_libdir)/lib${PN}.dynlib
	if use java ; then
		cp lib${PN}j.0.0.0.dynlib ${ED}/usr/$(get_libdir)/lib${PN}j.0.0.0.dynlib
		dosym lib${PN}j.0.0.0.dynlib /usr/$(get_libdir)/lib${PN}j.0.dynlib
		dosym lib${PN}j.0.0.0.dynlib /usr/$(get_libdir)/lib${PN}j.dynlib
	fi
	if use static-libs ; then
		dolib lib${PN}.a
	fi
	cd ../..

	use doc && dohtml doc/*
}
