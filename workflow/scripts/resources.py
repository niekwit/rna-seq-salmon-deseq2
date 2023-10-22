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
            self.gencode_fa_url = f"{base_url_gencode}human/release_{build}/GRCh38.p14.genome.fa.gz"
            self.gencode_trx_fa_url = f"{base_url_gencode}human/release_{build}/gencode.v{build}.transcripts.fa.gz"
            self.gencode_gtf_url = f"{base_url_gencode}human/release_{build}/gencode.v{build}.annotation.gtf.gz"
                        
            # set sha256sums for unzipped genome files
            self.gencode_fa_sha256 = "3ed0c28ded22eac00112e47331c3e146f5c0a50b9dbe2d15dac818ce2a8103df"
            self.gencode_trx_fa_sha256 = "103e0632a36c839a2e5717040c1a4fdb259c3b8a57d4e664335717e02507c4f0"
            self.gencode_gtf_sha256 = "46fc6e733fc73b236ffa68b770c5ee0cedd998797107cb4691bd8ca5c104df16"
                      
        elif genome.lower() == "mouse":
            # create URLs for genome files
            self.gencode_fa_url = f"{base_url_gencode}mouse/release_{build}/GRCm39.genome.fa.gz"
            self.gencode_trx_fa_url = f"{base_url_gencode}mouse/release_{build}/gencode.v{build}.transcripts.fa.gz"
            self.gencode_gtf_url = f"{base_url_gencode}mouse/release_{build}/gencode.v{build}.annotation.gtf.gz"
            
            # set sha256sums for unzipped genome files
            self.gencode_fa_sha256 = "08dc6846bb559fb0f2e12e9d0a970076ee77b2cd09b57e8f58cfab206fde5033"
            self.gencode_trx_fa_sha256 = "aef4f331d51c13e475cd40984818b2205ef5de2c8fbe720e0c9ee42d4650092b"
            self.gencode_gtf_sha256 = "43f54fea7b0ea8030851a669f92c7104f3869572543b27781b2f61cc469f3da0"
            
        # downloaded unzipped file names
        self.gencode_fasta = self.file_from_url(self.gencode_fa_url)
        self.gencode_trx_fasta = self.file_from_url(self.gencode_trx_fa_url)
        self.gencode_gtf = self.file_from_url(self.gencode_gtf_url)
        
    def _file_from_url(self, url):
        """Returns file path for unzipped downloaded file
        """
        
        return f"resources/{os.path.basename(url).replace('.gz','')}"
    
    
  
        
        
            
            
    