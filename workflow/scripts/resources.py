import os

class Resources:
    """Gets URLs and file names of fasta and GTF files for a given genome and build
    """
    # create genome directory
    os.makedirs("resources/", exist_ok=True)
    
    def __init__(self, genome, build):
        self.genome = genome
        self.build = str(build)
        
        human_assembly_version = {
            47: "p14",
            46: "p14",
            45: "p14",
            44: "p14",
            43: "p13",
            42: "p13",
            41: "p13",
            40: "p13",
            39: "p13",
            38: "p13",
            37: "p13",
            36: "p13",
            35: "p13",
            34: "p13",
            33: "p13",
            32: "p13",
            31: "p12",
            30: "p12",
            29: "p12",
            28: "p12",
            27: "p10",
            26: "p10",
            25: "p7",        
        }
        
        mouse_assembly_version = {
            "M36": "GRCm39",
            "M35": "GRCm39",
            "M34": "GRCm39",
            "M33": "GRCm39",
            "M32": "GRCm39",
            "M31": "GRCm39",
            "M30": "GRCm39",
            "M29": "GRCm39",
            "M28": "GRCm39",
            "M27": "GRCm39",
            "M26": "GRCm39",
            "M25": "GRCm39.p6",
            "M24": "GRCm39.p6",
            "M23": "GRCm39.p6",
            "M22": "GRCm39.p6",
            "M21": "GRCm39.p6",
            "M20": "GRCm39.p6",
            "M19": "GRCm39.p6",
            "M18": "GRCm39.p6",
            "M17": "GRCm39.p6",
            "M16": "GRCm39.p5",
            "M15": "GRCm39.p5",
            "M14": "GRCm39.p5",
            "M13": "GRCm39.p5",
            "M12": "GRCm39.p5",
        }
                
        # base URL
        base_url_gencode = "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_"
                
        if genome.lower() == "human":
            # create URLs for genome files
            av = human_assembly_version[build]
            
            self.fa_url = f"{base_url_gencode}human/release_{build}/GRCh38.{av}.genome.fa.gz"
            self.trx_fa_url = f"{base_url_gencode}human/release_{build}/gencode.v{build}.transcripts.fa.gz"
            self.gtf_url = f"{base_url_gencode}human/release_{build}/gencode.v{build}.annotation.gtf.gz"
                      
        elif genome.lower() == "mouse":
            # create URLs for genome files
            av = mouse_assembly_version[build]
            
            self.fa_url = f"{base_url_gencode}mouse/release_{build}/{av}.genome.fa.gz"
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
