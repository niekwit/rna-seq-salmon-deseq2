import os

class Resources:
    """Gets URLs and file names of fasta and GTF files for a given genome and build
    """
    
    # create genome directory
    os.makedirs("resources/", exist_ok=True)
    
    def __init__(self, genome, build):
        self.genome = genome
        self.build = build
                
        # base URL
        base_url_gencode = "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_"
                
        if genome.lower() == "human":
            # create URLs for genome files
            self.fa_url = f"{base_url_gencode}human/release_{build}/GRCh38.p14.genome.fa.gz"
            self.trx_fa_url = f"{base_url_gencode}human/release_{build}/gencode.v{build}.transcripts.fa.gz"
            self.gtf_url = f"{base_url_gencode}human/release_{build}/gencode.v{build}.annotation.gtf.gz"
                      
        elif genome.lower() == "mouse":
            # create URLs for genome files
            self.fa_url = f"{base_url_gencode}mouse/release_{build}/GRCm39.genome.fa.gz"
            self.trx_fa_url = f"{base_url_gencode}mouse/release_{build}/gencode.v{build}.transcripts.fa.gz"
            self.gtf_url = f"{base_url_gencode}mouse/release_{build}/gencode.v{build}.annotation.gtf.gz"
        
        elif genome == "test":
            # Download very small fasta files from Github repository
            self.fa_url = "https://github.com/niekwit/rna-seq-salmon-deseq2/raw/main/.test/GRCh38.p14.chr22.fa.gz"
            self.trx_fa_url = "https://github.com/niekwit/rna-seq-salmon-deseq2/raw/main/.test/gencode.v44.transcripts.chr22.fa.gz"
            self.gtf_url = "https://github.com/niekwit/rna-seq-salmon-deseq2/raw/main/.test/gencode.v44.annotation.chr22.gtf.gz"
        else:
            raise ValueError("Invalid genome selected...\nPlease select 'human', 'mouse' or 'test' as genome and provide a valid Gencode build number.")
        
        # downloaded unzipped file names
        self.fasta = self._file_from_url(self.fa_url)
        self.trx_fasta = self._file_from_url(self.trx_fa_url)
        self.gtf = self._file_from_url(self.gtf_url)

    def _file_from_url(self, url):
        """Returns file path for unzipped downloaded file
        """
        
        return f"resources/{os.path.basename(url).replace('.gz','')}"
