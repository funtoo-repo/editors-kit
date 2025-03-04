# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg cmake kde5

DESCRIPTION="Lightweight Qt5 Plain-Text Editor for Linux"
HOMEPAGE="https://github.com/tsujan/FeatherPad"
SRC_URI="https://github.com/tsujan/FeatherPad/releases/download/V1.6.1/FeatherPad-1.6.1.tar.xz -> FeatherPad-1.6.1.tar.xz"
S="${WORKDIR}/FeatherPad-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE="+X"

RDEPEND="app-text/hunspell
	$(add_qt_dep qtcore)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
		x11-libs/libXext
	)"
DEPEND="${RDEPEND}"
BDEPEND="$(add_qt_dep linguist-tools)"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_X11=$(usex !X)
	)
	cmake_src_configure
}