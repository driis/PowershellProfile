function paket() {
	if (-Not (test-path ".paket/paket.exe")) {
		if (-Not (test-path ".paket/paket.bootstrapper.exe")) {
			throw ".paket/paket.exe or .paket/paket.bootstrapper.exe was not found !"
		}
		.paket/paket.bootstrapper.exe
	}
	.paket/paket.exe $args
}

function get-paket()
{
	if (-Not (test-path ".paket")) {
		mkdir .paket
	}
	if (-Not (test-path ".paket/paket.bootstrapper.exe")) {
		curl https://github.com/fsprojects/Paket/releases/download/3.21.3/paket.bootstrapper.exe -o .paket/paket.bootstrapper.exe
	}
	if (-Not (test-path ".paket/paket.exe")) {
		.paket/paket.bootstrapper.exe
  }
}
