--exclui banco de dados se existe: 'uvv'
DROP DATABASE IF EXISTS uvv;

--exclui usuário se existe:'rebeca'
DROP USER IF EXISTS rebeca;

--cria usuário rebeca
CREATE USER rebeca WITH CREATEDB CREATEROLE ENCRYPTED PASSWORD 'beca';

--cria banco de dados 'uvv'
CREATE DATABASE uvv WITH OWNER rebeca TEMPLATE 'template0' ENCODING 'UTF8' LC_COLLATE 'pt_BR.UTF-8' LC_CTYPE 'pt_BR.UTF-8' ALLOW_CONNECTIONS 'true';

--conecta com banco de dados 'uvv'

\c uvv

--muda o usuário de 'postgres' para 'rebeca'
SET ROLE rebeca;


--mostra usuário atual conectado
SELECT SESSION_USER, CURRENT_USER;


--cria schema 'lojas'
CREATE SCHEMA lojas AUTHORIZATION rebeca;

--seleciona o schema corrente
SELECT CURRENT_SCHEMA();

--mostra a search_path
SHOW SEARCH_PATH;

--altera o search_path para o usuário criado
SET SEARCH_PATH TO lojas, "$user", public;

--altera a mudança do search_path de forma permanente para meu usuário
ALTER USER rebeca
SET SEARCH_PATH TO lojas, "$user", public;


--seleciona o schema corrente
SELECT CURRENT_SCHEMA();

--mostra a search_path
SHOW SEARCH_PATH;


--cria comentário para banco de dados 'uvv':
COMMENT ON DATABASE uvv IS 'Banco de dados "uvv" criado a partir de instruções de um PSET referente a disciplina Banco de Dados I';

--cria comentário para schema 'lojas':
COMMENT ON SCHEMA lojas IS 'Schema "lojas" com seguintes tabelas: clientes, produtos, lojas, pedidos, envios, pedidos_itens e estoques';

--TABELAS COM CHAVES PRIMÁRIAS E COMENTÁRIOS

-- cria tabela 'clientes' com chave primária:
CREATE TABLE clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20) NOT NULL,
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT pk_clientes PRIMARY KEY (cliente_id)
);

--cria comentário na tabela 'clientes':
COMMENT ON TABLE clientes IS 'Tabela dos Clientes';

--cria comentários nas colunas da tabela 'clientes':
COMMENT ON COLUMN clientes.cliente_id IS 'ID de cada cliente. Chave primária da tabela clientes. Coluna NOT NULL';
COMMENT ON COLUMN clientes.email IS 'Email de cada cliente. Coluna NOT NULL';
COMMENT ON COLUMN clientes.nome IS 'Nome de cada cliente. Coluna NOT NULL';
COMMENT ON COLUMN clientes.telefone1 IS 'Primeiro telefone para contato de cada cliente. Coluna NOT NULL';
COMMENT ON COLUMN clientes.telefone2 IS 'Segundo telefone para contato de cada cliente.';
COMMENT ON COLUMN clientes.telefone3 IS 'Terceiro telefone para contato de cada cliente.';

--cria tabela 'produtos' com chave primária:
CREATE TABLE produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT pk_produtos PRIMARY KEY (produto_id)
);

--cria comentário na tabela 'produtos':
COMMENT ON TABLE produtos IS 'Tabela dos Produtos';

--cria comentários nas colunas da tabela 'produtos':
COMMENT ON COLUMN produtos.produto_id IS 'ID de cada produto. Chave primária da tabela produtos. Coluna NOT NULL';
COMMENT ON COLUMN produtos.nome IS 'Nome de cada produto. Coluna NOT NULL';
COMMENT ON COLUMN produtos.preco_unitario IS 'Preço unitário de cada produto. Não aceita valores negativos. Coluna NOT NULL';
COMMENT ON COLUMN produtos.detalhes IS 'Detalhes de cada produto.';
COMMENT ON COLUMN produtos.imagem IS 'Imagem de cada produto.';
COMMENT ON COLUMN produtos.imagem_mime_type IS 'MIME type da imagem.';
COMMENT ON COLUMN produtos.imagem_arquivo IS 'Arquivo da imagem.';
COMMENT ON COLUMN produtos.imagem_charset IS 'Charset da imagem.';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'Última atualização da imagem.';

--cria tabela 'lojas' com chave primária:
CREATE TABLE lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT pk_lojas PRIMARY KEY (loja_id)
);
--cria comentário na tabela 'lojas':
COMMENT ON TABLE lojas IS 'Tabela das Lojas';

--cria comentários nas colunas da tabela 'lojas':
COMMENT ON COLUMN lojas.loja_id IS 'ID de cada loja. Chave primária da tabela lojas. Coluna NOT NULL';
COMMENT ON COLUMN lojas.nome IS 'Nome de cada loja. Coluna NOT NULL';
COMMENT ON COLUMN lojas.endereco_web IS 'Endereço web de cada loja. Coluna NOT NULL por meio da constraint de checagem';
COMMENT ON COLUMN lojas.endereco_fisico IS 'Endereço físico de cada loja. Coluna NOT NULL por meio da constraint de checagem';
COMMENT ON COLUMN lojas.latitude IS 'Latitude de cada loja.';
COMMENT ON COLUMN lojas.longitude IS 'Longitude de cada loja.';
COMMENT ON COLUMN lojas.logo IS 'Logo de cada loja.';
COMMENT ON COLUMN lojas.logo_mime_type IS 'MIME type da logo.';
COMMENT ON COLUMN lojas.logo_arquivo IS 'Tipo de arquivo da logo.';
COMMENT ON COLUMN lojas.logo_charset IS 'Charset da logo.';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'Última atualização da logo.';

--cria tabela 'pedidos' com chave primária:
CREATE TABLE pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id)
);
--cria comentário na tabela 'pedidos':
COMMENT ON TABLE pedidos IS 'Tabela dos Pedidos';

--cria comentários nas colunas da tabela 'pedidos':
COMMENT ON COLUMN pedidos.pedido_id IS 'ID de cada pedido. Chave primária da tabela pedidos. Coluna NOT NULL';
COMMENT ON COLUMN pedidos.data_hora IS 'Data e hora de emissão de cada pedido. Coluna NOT NULL';
COMMENT ON COLUMN pedidos.cliente_id IS 'ID de cada cliente. Foreign Key da tabela clientes. Coluna NOT NULL';
COMMENT ON COLUMN pedidos.status IS 'Status de cada pedido. Aceita somente valores: CANCELADO, COMPLETO, ABERTO, PAGO, REEMBOLSADO e
ENVIADO. Coluna NOT NULL' ;
COMMENT ON COLUMN pedidos.loja_id IS 'ID de cada loja. Foreign key da tabela lojas. Coluna NOT NULL';

--cria tabela 'envios' com chave primária:
CREATE TABLE envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT pk_envios PRIMARY KEY (envio_id)
);

--cria comentário na tabela 'envios':
COMMENT ON TABLE envios IS 'Tabela dos Envios';

--cria comentários nas colunas da tabela 'envios':
COMMENT ON COLUMN envios.envio_id IS 'ID de cada envio. Chave primária da tabela envios. Coluna NOT NULL';
COMMENT ON COLUMN envios.loja_id IS 'ID de cada loja. Foreign key da tabela lojas. Coluna NOT NULL';
COMMENT ON COLUMN envios.cliente_id IS 'ID de cada cliente. Foreign key da tabela clientes. Coluna NOT NULL';
COMMENT ON COLUMN envios.endereco_entrega IS 'Endereço de entrega de cada envio. Coluna NOT NULL';
COMMENT ON COLUMN envios.status IS 'Status de cada envio. Aceita somente valores: CRIADO, ENVIADO, TRANSITO e ENTREGUE. Coluna NOT NULL';

--cria tabela 'pedidos_itens' com chave primária:
CREATE TABLE pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);

--cria comentário na tabela 'pedidos_itens':
COMMENT ON TABLE pedidos_itens IS 'Tabela dos Itens dos Pedidos';

--cria comentários nas colunas da tabela 'pedidos_itens':
COMMENT ON COLUMN pedidos_itens.pedido_id IS 'ID de cada pedido. Chave primária composta da tabela pedidos_itens. Coluna NOT NULL';
COMMENT ON COLUMN pedidos_itens.produto_id IS 'ID de cada produto. Chave primária composta da tabela pedidos_itens. Coluna NOT NULL';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 'Número da linha de cada produto em cada pedido. Coluna NOT NULL';
COMMENT ON COLUMN pedidos_itens.preco_unitario IS 'Preço unitário de cada produto. Não aceita valores negativos. Coluna NOT NULL';
COMMENT ON COLUMN pedidos_itens.quantidade IS 'Quantidade de cada produto em cada pedido. Não aceita valores negativos. Coluna NOT NULL';
COMMENT ON COLUMN pedidos_itens.envio_id IS 'ID de cada envio. Foreign key da tabela envios.';

--cria tabela 'estoques' com chave primária:
CREATE TABLE estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoque PRIMARY KEY (estoque_id)
);

--cria comentário na tabela 'estoques':
COMMENT ON TABLE estoques IS 'Tabela dos Estoques';

--cria comentários nas colunas da tabela 'estoques':
COMMENT ON COLUMN estoques.estoque_id IS 'ID de cada estoque. Chave primária da tabela estoques. Coluna NOT NULL';
COMMENT ON COLUMN estoques.loja_id IS 'ID de cada loja. Foreign key da tabela lojas. Coluna NOT NULL';
COMMENT ON COLUMN estoques.produto_id IS 'ID de cada produto. Foreign key da tabela produtos. Coluna NOT NULL';
COMMENT ON COLUMN estoques.quantidade IS 'Quantidade do produto no estoque. Não aceita valores negativos. Coluna NOT NULL';

--CHAVES ESTRANGEIRAS

--cria chave estrangeira na tabela 'envios' (relacionamento não identificado entre 'clientes' e 'envios'):
ALTER TABLE envios 
ADD CONSTRAINT fk_clientes_envios
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id);

--cria chave estrangeira na tabela 'pedidos' (relacionamento não identificado entre 'clientes' e 'pedidos'):
ALTER TABLE pedidos 
ADD CONSTRAINT fk_clientes_pedidos
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id);

--cria chave estrangeira na tabela 'estoques' (relacionamento não identificado entre 'estoques' e 'produtos'):
ALTER TABLE estoques 
ADD CONSTRAINT fk_produtos_estoques
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id);

--cria chave estrangeira na tabela 'pedidos_itens' (relacionamento identificado entre 'produtos' e 'pedidos_itens'):
ALTER TABLE pedidos_itens 
ADD CONSTRAINT fk_produtos_pedidos_itens
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id);
--cria chave estrangeira na tabela 'estoques' (relacionamento não identificado entre 'lojas' e 'estoques'):
ALTER TABLE estoques 
ADD CONSTRAINT fk_lojas_estoques
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id);

--cria chave estrangeira na tabela 'envios' (relacionamento não identificado entre 'lojas' e 'envios'):
ALTER TABLE envios 
ADD CONSTRAINT fk_lojas_envios
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id);

--cria chave estrangeira na tabela 'pedidos' (relacionamento não identificado entre 'lojas' e 'pedidos'):
ALTER TABLE pedidos 
ADD CONSTRAINT fk_lojas_pedidos
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id);

--cria chave estrangeira na tabela 'pedidos_itens' (relacionamento identificado entre 'pedidos' e 'pedidos_itens'):
ALTER TABLE pedidos_itens 
ADD CONSTRAINT fk_pedidos_pedidos_itens
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id);

--cria chave estrangeira na tabela 'pedidos_itens' (relacionamento não identificado entre 'envios' e 'pedidos_itens'):
ALTER TABLE pedidos_itens 
ADD CONSTRAINT fk_envios_pedidos_itens
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id);

--CONSTRAINT DE CHECAGEM

/*cria constraint de checagem para coluna 'status' da tabela 'pedidos',
no qual só são aceitos valores: CANCELADO, COMPLETO, ABERTO, PAGO, REEMBOLSADO e ENVIADO:
*/
ALTER TABLE pedidos
ADD CONSTRAINT cc_pedidos_status
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

/*cria constraint de checagem para coluna 'preco_unitario' da tabela 'produtos',
no qual só são aceitos valores maiores que zero:
*/
ALTER TABLE produtos
ADD CONSTRAINT cc_produtos_preco_unitario
CHECK (preco_unitario > 0);

/*cria constraint de checagem para coluna 'quantidade' da tabela 'estoques',
no qual só são aceitos valores maiores que zero:
*/
ALTER TABLE estoques
ADD CONSTRAINT cc_estoques_quantidade
CHECK (quantidade > 0);

/*cria constraint de checagem para coluna 'preco_unitario' da tabela 'pedidos_itens',
no qual só são aceitos valores maiores que zero:
*/
ALTER TABLE pedidos_itens
ADD CONSTRAINT cc_pedidos_itens_preco_unitario
CHECK (preco_unitario > 0);

/*cria constraint de checagem para coluna 'quantidade' da tabela 'pedidos_itens',
no qual só são aceitos valores maiores que zero:
*/
ALTER TABLE pedidos_itens
ADD CONSTRAINT cc_pedidos_itens_quantidade
CHECK (quantidade > 0);

/*cria constraint de checagem para colunas 'endereco_web' e 'endereco_fisico' da tabela 'lojas',
no qual nenhuma das colunas pode estar nula ao mesmo tempo:
*/
ALTER TABLE lojas
ADD CONSTRAINT cc_lojas_endereco_web_fisico
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

/*cria constraint de checagem para coluna 'status' da tabela 'envios',
no qual só são aceitos valores: CRIADO, ENVIADO, TRANSITO e ENTREGUE:
*/
ALTER TABLE envios
ADD CONSTRAINT cc_envios_status
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

--PROJETO CONCLUÍDO!
