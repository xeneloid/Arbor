# Copyright 2007-2008 Mike Kelly <pioto@exherbo.org>
# Copyright 2008 Ingmar Vanhassel <ingmar@exherbo.org>
# Distributed under the terms of the GPLv2

require multilib perl-module bash-completion

DESCRIPTION="A distributed VCS focused on speed, effectivity and real-world
usability on large projects."
HOMEPAGE="http://git.or.cz/"
SRC_URI="mirror://kernel/software/scm/${PN}/${P}.tar.bz2
    mirror://kernel/software/scm/${PN}/${PN}-manpages-${PV}.tar.bz2
    doc? ( mirror://kernel/software/scm/${PN}/${PN}-htmldocs-${PV}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
PLATFORMS="~amd64 ~x86"
MYOPTIONS="curl doc ipv6 threads webdav" # cgi (gitweb), tk, vim-syntax ("${S}"contrib/vim)

DEPENDENCIES="
build+run:
    app-arch/cpio
    dev-lang/perl
    dev-libs/openssl
    sys-libs/zlib
    curl? ( net-misc/curl )
    webdav? ( dev-libs/expat )
run:
    dev-perl/Error
post,suggested:
    dev-scm/subversion[perl]  [[ description = [ Dependency for git-svn ] ]]
    dev-perl/libwww-perl      [[ description = [ Dependency for git-svn ] ]]
    dev-perl/TermReadKey      [[ description = [ Dependency for git-svn ] ]]
    dev-perl/Authen-SASL   [[ description = [ Dependency for git-send-email ] ]]
    dev-perl/Net-SMTP-SSL  [[ description = [ Dependency for git-send-email ] ]]
    virtual/mta            [[ description = [ Dependency for git-send-email ] ]]
"

#   tk? ( dev-lang/tk )
#   cvs: ( dev-scm/cvsps dev-perl/DBI dev-perl/DBI-SQLite )

pkg_pretend() {
    if ! option curl && option webdav; then
        die 'OPTION="webdav" needs the "curl" option.'
    fi
}

src_unpack() {
    unpack ${P}.tar.bz2
    cd "${S}"
    unpack ${PN}-manpages-${PV}.tar.bz2
    if option doc; then
        cd Documentation && unpack ${PN}-htmldocs-${PV}.tar.bz2
    fi
}

# No option: mozsha1/ppcsha1
src_configure() {
    myoptions+=" NO_TCLTK=YesPlease"
    option curl || myoptions+=" NO_CURL=YesPlease"
    option ipv6 || myoptions+=" NO_IPV6=YesPlease"
    option threads && myoptions+=" THREADED_DELTA_SEARCH=YesPlease"
    option webdav || myoptions+=" NO_EXPAT=YesPlease"
#   option tk || myoptions+=" NO_TCLTK=YesPlease"
}

myemake() {
    emake \
        DESTDIR="${D}" \
        prefix=/usr \
        gitexecdir=/usr/$(get_libdir)/${PN} \
        CFLAGS="${CFLAGS} -Wall" \
        LDFLAGS="${LDFLAGS}" \
        ${myoptions} "${@}"
}

src_compile() {
    myemake all
}

src_test() {
    # default_src_test executes the wrong target, "make check", first
    myemake test
}

src_install() {
    myemake install

    doman man?/*

    dodoc README Documentation/{SubmittingPatches,CodingGuidelines}
    for d in / /howto/ /technical/ ; do
        docinto ${d}
        dodoc Documentation${d}*.txt
        if option doc; then
            dodir /usr/share/doc/${PF}/html/
            insinto /usr/share/doc/${PF}/html/
            doins Documentation${d}*.html
        fi
    done
    docinto /

    dobashcompletion contrib/completion/git-completion.bash ${PN}

    fixlocalpod

    keepdir /usr/share/git-core/templates/branches
}

