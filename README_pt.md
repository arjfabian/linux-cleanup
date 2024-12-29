**Idiomas disponíveis**:

[![English](https://raw.githubusercontent.com/arjfabian/arjfabian/main/assets/icons/flags/gb.png)](README.md)
[![Español](https://raw.githubusercontent.com/arjfabian/arjfabian/main/assets/icons/flags/es.png)](README_es.md)
[![Português](https://raw.githubusercontent.com/arjfabian/arjfabian/main/assets/icons/flags/pt.png)](README_pt.md)

# Linux Cleanup

Este script ajuda você a remover todos os pacotes do seu sistema que não estão listados em uma lista de pacotes base fornecida. Isso pode ser útil para:

* **Limpeza do sistema:** Remover pacotes desnecessários para liberar espaço em disco.

* **Fortalecimento do sistema:** Reduzir a superfície de ataque removendo softwares potencialmente vulneráveis.

* **Criação de um sistema mínimo:** Manter um sistema limpo e minimalista com apenas os pacotes essenciais.

**Observação:**

* Este script **não** garante a exclusão de arquivos de configuração existentes, apenas os pacotes em si. Se você deseja excluir arquivos de configuração, execute uma execução simulada (veja [Argumentos Opcionais](#argumentos-opcionais) para obter mais informações) e verifique a documentação de cada pacote afetado.

* ⚠️ **Use com cautela:** Sempre faça um backup do seu sistema antes de executar este script. A remoção de pacotes pode levar a consequências indesejadas, como:

  * Remover bibliotecas críticas do sistema.
  * Quebrar dependências para aplicativos essenciais.
  * Desinstalar atualizações de segurança importantes.

## Como usar

1. **Baixe o script:** Salve o script em sua máquina local.

2. **Crie um arquivo `pkgs.base`:**

    - **Geração automática:** Consulte a seção [Criação de arquivo de pacotes base](#criação-do-arquivo-de-pacotes-base) para obter mais informações sobre os gerenciadores de pacotes compatíveis.

    - **Criação manual (para usuários avançados):** Crie um arquivo de texto chamado `pkgs.base` contendo uma lista de pacotes essenciais para o seu sistema.

3. **Execute o script:**

    - Execute o script a partir da linha de comando:

       ```bash
       ./linux-cleanup.sh 
       ```

### Argumentos opcionais

* `--dry-run`: Realize uma execução simulada. Exibe a lista de pacotes que seriam removidos sem realmente removê-los.

* `--base-file`: Especifica o caminho para o arquivo de pacotes base (padrão: `pkgs.base`). 

## Gerenciadores de pacotes compatíveis

* APT (Debian, Ubuntu, Linux Mint, Pop!_OS)
* DNF (Fedora, Red Hat, CentOS 8+)
* Guix
* Homebrew (macOS)
* Nix
* Pacman (Arch Linux, Manjaro, EndeavourOS)
* Pkg (Alpine Linux)
* Portage (Gentoo)
* YUM (CentOS, Red Hat)
* Zypper (openSUSE, SUSE Linux Enterprise)

## Criação do arquivo de pacotes base

Você pode criar o arquivo no seu sistema atual ou em uma instalação "limpa", dependendo de suas necessidades. Eu **fortemente** sugiro garantir que o sistema esteja em um estado desejável (ou seja, estável e sem pacotes desnecessários).

* **Sugestão:** Faça uma instalação "mínima" em uma máquina virtual, execute o comando apropriado e exporte o resultado para obter um arquivo base limpo.

O arquivo `pkgs.base.archlinux` incluso corresponde à minha própria instalação "minimalista" do Arch Linux, mas não posso garantir que esta configuração funcione para a maioria dos usuários.

### Pacman (Arch Linux, Manjaro, EndeavourOS)

```bash
pacman -Q | awk '{ print $1 }' > pkgs.base
```

### APT (Debian, Ubuntu, Linux Mint, Pop!_OS)

```bash
dpkg-query -W -f='${binary:Package}\n' | sort > pkgs.base
```

### DNF (Fedora, Red Hat, CentOS 8+)

```bash
dnf list installed | awk '{print $1}' | tail -n +2 | sort > pkgs.base 
```

### Guix

```bash
guix package list | awk '{print $1}' | sort > pkgs.base
```

### Homebrew (macOS)

```bash
brew list | sort > pkgs.base
```

### Nix

```bash
nix-env -qa --out-fmt '{ name, version }' | jq -r '.name' | sort > pkgs.base
```

### Pkg (Alpine Linux)

```bash
apk info -v | awk '{print $1}' | sort > pkgs.base
```

### Portage (Gentoo)

```bash
qlist -I | sort > pkgs.base
```

### YUM (CentOS, Red Hat)

```bash
yum list installed | awk '{print $1}' | tail -n +2 | sort > pkgs.base 
```

### Zypper (openSUSE, SUSE Linux Enterprise)

```bash
zypper se --installed-only | awk '{print $2}' | sort > pkgs.base
```

## Isenção de responsabilidade

Este script é fornecido "como está", sem qualquer garantia. Use-o por sua conta e risco. O autor não é responsável por quaisquer danos causados pelo uso deste script.

## Contribuições

Contribuições e sugestões são bem-vindas. Sinta-se à vontade para contribuir e melhorar este script.
