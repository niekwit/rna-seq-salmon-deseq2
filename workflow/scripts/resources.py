import os
import re
import urllib.error
import urllib.request


class Resources:
    """Gets URLs and file names of fasta and GTF files for a given genome and build"""

    # create genome directory
    os.makedirs("resources/", exist_ok=True)

    def __init__(self, genome, build):
        self.genome = genome
        self.build = str(build)

        # base URL
        base_url_gencode = "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_"

        if genome.lower() == "human":
            release_url = f"{base_url_gencode}human/release_{build}/"
            genome_filename = self._genome_fasta_filename(
                release_url, "GRCh", build, "human"
            )

            self.fa_url = f"{release_url}{genome_filename}"
            self.trx_fa_url = f"{release_url}gencode.v{build}.transcripts.fa.gz"
            self.gtf_url = f"{release_url}gencode.v{build}.annotation.gtf.gz"

        elif genome.lower() == "mouse":
            release_url = f"{base_url_gencode}mouse/release_{build}/"
            genome_filename = self._genome_fasta_filename(
                release_url, "GRCm", build, "mouse"
            )

            self.fa_url = f"{release_url}{genome_filename}"
            self.trx_fa_url = f"{release_url}gencode.v{build}.transcripts.fa.gz"
            self.gtf_url = f"{release_url}gencode.v{build}.annotation.gtf.gz"

        elif genome == "test":
            # Download very small fasta files from Github repository
            self.fa_url = "https://github.com/niekwit/rna-seq-salmon-deseq2/raw/main/.test/GRCh38.p14.chr22.fa.gz"
            self.trx_fa_url = "https://github.com/niekwit/rna-seq-salmon-deseq2/raw/main/.test/gencode.v44.transcripts.chr22.fa.gz"
            self.gtf_url = "https://github.com/niekwit/rna-seq-salmon-deseq2/raw/main/.test/gencode.v44.annotation.chr22.gtf.gz"
        else:
            raise ValueError(
                "Invalid genome selected...\nPlease select 'human', 'mouse' or 'test' as genome and provide a valid Gencode build number."
            )

        # downloaded unzipped file names
        self.fasta = self._file_from_url(self.fa_url)
        self.trx_fasta = self._file_from_url(self.trx_fa_url)
        self.gtf = self._file_from_url(self.gtf_url)

    @staticmethod
    def _genome_fasta_filename(release_url, assembly_prefix, build, species):
        """
        Determine the genome fasta filename for a Gencode release by listing
        its FTP directory, instead of relying on a manually maintained
        build -> assembly-patch-version mapping (which needs updating by hand
        every time Gencode makes a new release).

        The genome fasta filename itself encodes the assembly patch version,
        e.g. GRCh38.p14.genome.fa.gz or GRCm39.genome.fa.gz.
        """
        try:
            with urllib.request.urlopen(release_url, timeout=30) as response:
                listing = response.read().decode("utf-8", errors="replace")
        except urllib.error.HTTPError as e:
            raise ValueError(
                f"Could not find Gencode release {build} for {species} at {release_url} "
                f"(HTTP error: {e}). Please check that 'gencode_genome_build' in "
                "config.yml is a valid Gencode release number for this species."
            ) from e
        except urllib.error.URLError as e:
            raise ValueError(
                f"Could not reach the Gencode FTP server at {release_url} ({e.reason}). "
                "Check your internet connection and try again."
            ) from e

        # Match e.g. "GRCh38.p14.genome.fa.gz" or "GRCm39.genome.fa.gz", but not
        # the "*.primary_assembly.genome.fa.gz" variant also present in the listing.
        pattern = re.compile(
            rf'href="({re.escape(assembly_prefix)}\d+(?:\.p\d+)?\.genome\.fa\.gz)"'
        )
        match = pattern.search(listing)
        if not match:
            raise ValueError(
                f"Could not determine the genome assembly version for Gencode release "
                f"{build} ({species}) from {release_url}. Either the Gencode FTP page "
                "layout has changed and this workflow needs updating, or "
                "'gencode_genome_build' in config.yml is invalid."
            )

        return match.group(1)

    def _file_from_url(self, url):
        """Returns file path for unzipped downloaded file"""

        return f"resources/{os.path.basename(url).replace('.gz','')}"
