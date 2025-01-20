# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A post-modern modal text editor"
HOMEPAGE="https://github.com/helix-editor/helix"
SRC_URI="https://github.com/helix-editor/helix/tarball/60b93dec398b289da148a4716f27843f644122a2 -> helix-25.01.1-60b93de.tar.gz
https://direct-github.funmore.org/c8/9c/a2/c89ca21ff5212eb7ae720ff2f453a4a61f044e6d5321e9faa36dacb013f0fa67f90871807c381187f80e93871bb21925a3a926834a6319da80b8e46a35788396 -> helix-25.01.1-funtoo-crates-bundle-5dba7b6dd80178e997100642a7a03edd9ba030faa723c852f51c57b98078d2452e206decb582f6f79bd9905be1f63190c93857f753d05330007e94399c73a419.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

S="${WORKDIR}/helix-editor-helix-60b93de"

src_compile() {
	export HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1

	cargo_src_compile
}

src_install() {
	rm -rf ${S}/runtime/grammars/sources

	insinto /usr/share/helix
	doins -r runtime
 
	use doc && dodoc README.md CHANGELOG.md
	use doc && dodoc -r docs/

	cargo_src_install --path helix-term
}

pkg_postinst() {
	elog "You will need to copy /usr/share/helix/runtime into your \$HELIX_RUNTIME"
	elog "For syntax highlighting and other features. "
	elog ""
	elog "Run: "
	elog "cp -r /usr/share/helix/runtime ~/.config/helix/runtime"
	elog ""
	elog "To install tree-sitter grammars for helix run the following:"
	elog "hx -g fetch"
	elog "hx -g build"
}