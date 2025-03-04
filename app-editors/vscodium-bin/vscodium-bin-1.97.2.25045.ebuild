# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils pax-utils xdg

MY_INSTALL_DIR="/opt/${PN}"
MY_EXEC="codium"
DESCRIPTION="Community-driven, freely-licensed binary distribution of Microsoft’s editor VSCode"
HOMEPAGE="https://vscodium.com/"
SRC_URI="https://github.com/VSCodium/vscodium/releases/download/1.97.2.25045/VSCodium-linux-x64-1.97.2.25045.tar.gz -> VSCodium-linux-x64-1.97.2.25045.tar.gz"
RESTRICT="strip"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="libsecret hunspell"
S="$WORKDIR"

DEPEND="
	media-libs/libpng
	>=x11-libs/gtk+-3.0
	x11-libs/cairo
	x11-libs/libXtst
"

RDEPEND="
	${DEPEND}
	>=net-print/cups-2.0.0
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	dev-libs/nss
	hunspell? ( app-text/hunspell )
	libsecret? ( app-crypt/libsecret[crypt] )
"
src_install() {
	pax-mark m "${MY_INSTALL_DIR}/${MY_EXEC}"
	insinto "${MY_INSTALL_DIR}"
	doins -r *
	dosym "${MY_INSTALL_DIR}/${MY_EXEC}" "/usr/bin/${PN}"
	make_wrapper "${PN}" "${MY_INSTALL_DIR}/${MY_EXEC}"
	domenu ${FILESDIR}/${PN}.desktop
	newicon ${S}/resources/app/resources/linux/code.png ${PN}.png

	fperms +x "${MY_INSTALL_DIR}/${MY_EXEC}"
	fperms 4755 "${MY_INSTALL_DIR}/chrome-sandbox"
	fperms +x "${MY_INSTALL_DIR}/libEGL.so"
	fperms +x "${MY_INSTALL_DIR}/libGLESv2.so"
	fperms +x "${MY_INSTALL_DIR}/libffmpeg.so"

	#fix Spawn EACESS bug #25848
	fperms +x "${MY_INSTALL_DIR}/resources/app/node_modules.asar.unpacked/@vscode/ripgrep/bin/rg"
	insinto "/usr/share/licenses/${PN}"
	newins "${S}/resources/app/LICENSE.txt" "LICENSE.txt"
}

pkg_postinst() {
        xdg_icon_cache_update
	xdg_desktop_database_update
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}

pkg_postrm() {
	xdg_desktop_database_update
        xdg_icon_cache_update
}