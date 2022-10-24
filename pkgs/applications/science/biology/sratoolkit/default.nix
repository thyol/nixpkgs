{ stdenv, lib
, fetchurl
, autoPatchelfHook
, libidn
, zlib
, bzip2
}:

stdenv.mkDerivation rec {
  name = "sratoolkit";

  version = "2.11.3";

  libidn11 = libidn.overrideAttrs (old: {
    name = "libidn-1.34";
    src = fetchurl {
      url = "mirror://gnu/libidn/libidn-1.34.tar.gz";
      sha256 = "0g3fzypp0xjcgr90c5cyj57apx1cmy0c6y9lvw2qdcigbyby469p";
    };
  });
  
  src = fetchurl {
    url = "https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${version}/sratoolkit.${version}-ubuntu64.tar.gz";
    sha256 = "1590lc4cplxr3lhjqci8fjncy67imn2h14qd2l87chmhjh243qvx";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libidn11
    zlib
    bzip2
    stdenv.cc.cc.lib
  ];

  sourceRoot = "./sratoolkit.${version}-ubuntu64/bin";

  installPhase = ''
    for i in $(ls -p | grep -v / | grep -v remote-fuser ) ;  do
      install -m755 -D ./$i $out/bin/$i
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/ncbi/sra-tools";
    description = "SRA Tools";
  };
}
