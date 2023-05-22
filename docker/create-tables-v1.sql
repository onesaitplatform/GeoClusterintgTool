--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Debian 13.4-1.pgdg110+1)
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)

-- Started on 2023-03-09 15:37:52 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 29011)
-- Name: CODE_LIST; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."CODE_LIST" (
    urn character varying(300) NOT NULL,
    is_partial boolean,
    agency_id character varying(100),
    id character varying(100),
    is_final boolean,
    version character varying(20),
    name character varying(300)
);


--
-- TOC entry 202 (class 1259 OID 29023)
-- Name: CODE_LIST_ELEMENTS; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."CODE_LIST_ELEMENTS" (
    urn character varying(300) NOT NULL,
    code_list_urn character varying(300) NOT NULL,
    id character varying(100) NOT NULL,
    name character varying(300) NOT NULL
);


--
-- TOC entry 200 (class 1259 OID 28995)
-- Name: CONCEPT_SCHEME; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."CONCEPT_SCHEME" (
    urn character varying(300) NOT NULL,
    is_partial boolean,
    agency_id character varying(100),
    id character varying(100),
    is_final boolean,
    version character varying(20),
    name character varying(300)
);


--
-- TOC entry 203 (class 1259 OID 29036)
-- Name: CONCEPT_SCHEME_CONCEPTS; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."CONCEPT_SCHEME_CONCEPTS" (
    urn character varying(300) NOT NULL,
    id character varying(100) NOT NULL,
    name character varying(300),
    "textFormat" character varying(300),
    code_list_urn character varying(300),
    "isoConceptReference" character varying(300),
    concept_scheme_urn character varying(300) NOT NULL
);


--
-- TOC entry 210 (class 1259 OID 53550)
-- Name: DATAFLOW; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."DATAFLOW" (
    urn character varying(300) NOT NULL,
    agency_id character varying(100),
    id character varying(100),
    is_final boolean,
    version character varying(20),
    name character varying(300),
    data_structure_urn character varying(300)
);


--
-- TOC entry 204 (class 1259 OID 29049)
-- Name: DATA_STRUCTURE; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."DATA_STRUCTURE" (
    urn character varying(300) NOT NULL,
    agency_id character varying(100) NOT NULL,
    is_final boolean,
    version character varying(20) NOT NULL,
    name character varying(300),
    id character varying(100) NOT NULL
);


--
-- TOC entry 205 (class 1259 OID 29057)
-- Name: DATA_STRUCTURE_ANNOTATIONS; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."DATA_STRUCTURE_ANNOTATIONS" (
    title character varying(300) NOT NULL,
    data_structure_urn character varying(300) NOT NULL,
    type character varying(100),
    url character varying(300),
    text character varying(300)
);


--
-- TOC entry 208 (class 1259 OID 29117)
-- Name: DATA_STRUCTURE_ATTRIBUTES; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."DATA_STRUCTURE_ATTRIBUTES" (
    urn character varying(300) NOT NULL,
    data_structure_urn character varying(300) NOT NULL,
    id character varying(100),
    assigment_status character varying(100),
    concept_identity_urn character varying(300),
    text_format character varying(300),
    code_list_urn character varying(300),
    data_structure_measure_urn character varying(300)
);


--
-- TOC entry 206 (class 1259 OID 29070)
-- Name: DATA_STRUCTURE_DIMENSIONS; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."DATA_STRUCTURE_DIMENSIONS" (
    urn character varying(300) NOT NULL,
    data_structure_urn character varying(300) NOT NULL,
    id character varying(100),
    "position" integer,
    concept_scheme_urn character varying(300),
    text_format character varying(300),
    code_list_urn character varying(300)
);


--
-- TOC entry 209 (class 1259 OID 29140)
-- Name: DATA_STRUCTURE_MEASURE; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."DATA_STRUCTURE_MEASURE" (
    urn character varying(300) NOT NULL,
    data_structure_urn character varying(300) NOT NULL,
    id character varying(100),
    concept_identity_urn character varying(300),
    text_format character varying(300),
    code_list_urn character varying(300)
);


--
-- TOC entry 207 (class 1259 OID 29093)
-- Name: DATA_STRUCTURE_TIME_DIMENSIONS; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."DATA_STRUCTURE_TIME_DIMENSIONS" (
    urn character varying(300) NOT NULL,
    data_structure_urn character varying(300) NOT NULL,
    id character varying(100),
    "position" integer,
    concept_identity_urn character varying(300),
    text_format character varying(300),
    code_list_urn character varying(300)
);


--
-- TOC entry 3882 (class 2606 OID 29030)
-- Name: CODE_LIST_ELEMENTS CODE_LIST_ELEMENTS_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CODE_LIST_ELEMENTS"
    ADD CONSTRAINT "CODE_LIST_ELEMENTS_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3878 (class 2606 OID 29020)
-- Name: CODE_LIST CODE_LIST_UNIQUE; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CODE_LIST"
    ADD CONSTRAINT "CODE_LIST_UNIQUE" UNIQUE (id, version, agency_id);


--
-- TOC entry 3880 (class 2606 OID 29018)
-- Name: CODE_LIST CODE_LIST_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CODE_LIST"
    ADD CONSTRAINT "CODE_LIST_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3884 (class 2606 OID 29043)
-- Name: CONCEPT_SCHEME_CONCEPTS CONCEPT_SCHEME_CONCEPTS_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CONCEPT_SCHEME_CONCEPTS"
    ADD CONSTRAINT "CONCEPT_SCHEME_CONCEPTS_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3874 (class 2606 OID 29022)
-- Name: CONCEPT_SCHEME CONCEPT_SCHEME_UNIQUE; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CONCEPT_SCHEME"
    ADD CONSTRAINT "CONCEPT_SCHEME_UNIQUE" UNIQUE (id, version, agency_id);


--
-- TOC entry 3876 (class 2606 OID 29002)
-- Name: CONCEPT_SCHEME CONCEPT_SCHEME_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CONCEPT_SCHEME"
    ADD CONSTRAINT "CONCEPT_SCHEME_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3902 (class 2606 OID 53568)
-- Name: DATAFLOW DATAFLOW_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATAFLOW"
    ADD CONSTRAINT "DATAFLOW_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3896 (class 2606 OID 29124)
-- Name: DATA_STRUCTURE_ATTRIBUTES DATA_STRUCTURE_ATTRIBUTES_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_ATTRIBUTES"
    ADD CONSTRAINT "DATA_STRUCTURE_ATTRIBUTES_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3892 (class 2606 OID 29077)
-- Name: DATA_STRUCTURE_DIMENSIONS DATA_STRUCTURE_DIMENSIONS_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_DIMENSIONS"
    ADD CONSTRAINT "DATA_STRUCTURE_DIMENSIONS_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3898 (class 2606 OID 29147)
-- Name: DATA_STRUCTURE_MEASURE DATA_STRUCTURE_MEASURE_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_MEASURE"
    ADD CONSTRAINT "DATA_STRUCTURE_MEASURE_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3894 (class 2606 OID 29100)
-- Name: DATA_STRUCTURE_TIME_DIMENSIONS DATA_STRUCTURE_TIME_DIMENSIONS_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_TIME_DIMENSIONS"
    ADD CONSTRAINT "DATA_STRUCTURE_TIME_DIMENSIONS_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3886 (class 2606 OID 45352)
-- Name: DATA_STRUCTURE DATA_STRUCTURE_UNIQUE; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE"
    ADD CONSTRAINT "DATA_STRUCTURE_UNIQUE" UNIQUE (agency_id, id, version);


--
-- TOC entry 3888 (class 2606 OID 29056)
-- Name: DATA_STRUCTURE DATA_STRUCTURE_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE"
    ADD CONSTRAINT "DATA_STRUCTURE_pkey" PRIMARY KEY (urn);


--
-- TOC entry 3890 (class 2606 OID 29064)
-- Name: DATA_STRUCTURE_ANNOTATIONS PK_DATA_STRUCTURE_ANNOTATION; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_ANNOTATIONS"
    ADD CONSTRAINT "PK_DATA_STRUCTURE_ANNOTATION" PRIMARY KEY (title, data_structure_urn);


--
-- TOC entry 3900 (class 2606 OID 53544)
-- Name: DATA_STRUCTURE_MEASURE UNIQUE_DATA_STRUCTURE_MEASURE; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_MEASURE"
    ADD CONSTRAINT "UNIQUE_DATA_STRUCTURE_MEASURE" UNIQUE (data_structure_urn, id);


--
-- TOC entry 3903 (class 2606 OID 29031)
-- Name: CODE_LIST_ELEMENTS FK_CODE_LIST_ELEMENTS; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CODE_LIST_ELEMENTS"
    ADD CONSTRAINT "FK_CODE_LIST_ELEMENTS" FOREIGN KEY (code_list_urn) REFERENCES public."CODE_LIST"(urn);


--
-- TOC entry 3905 (class 2606 OID 37159)
-- Name: CONCEPT_SCHEME_CONCEPTS FK_CONCEPT_SCHEME; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CONCEPT_SCHEME_CONCEPTS"
    ADD CONSTRAINT "FK_CONCEPT_SCHEME" FOREIGN KEY (concept_scheme_urn) REFERENCES public."CONCEPT_SCHEME"(urn) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3904 (class 2606 OID 29044)
-- Name: CONCEPT_SCHEME_CONCEPTS FK_CONCEPT_SCHEME_CODE_LIST; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CONCEPT_SCHEME_CONCEPTS"
    ADD CONSTRAINT "FK_CONCEPT_SCHEME_CODE_LIST" FOREIGN KEY (code_list_urn) REFERENCES public."CODE_LIST"(urn);


--
-- TOC entry 3920 (class 2606 OID 53562)
-- Name: DATAFLOW FK_DATAFLOW_DATA_STRUCTURE; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATAFLOW"
    ADD CONSTRAINT "FK_DATAFLOW_DATA_STRUCTURE" FOREIGN KEY (data_structure_urn) REFERENCES public."DATA_STRUCTURE"(urn) NOT VALID;


--
-- TOC entry 3906 (class 2606 OID 29065)
-- Name: DATA_STRUCTURE_ANNOTATIONS FK_DATA_STRUCTURE_ANNOTATION; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_ANNOTATIONS"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_ANNOTATION" FOREIGN KEY (data_structure_urn) REFERENCES public."DATA_STRUCTURE"(urn);


--
-- TOC entry 3913 (class 2606 OID 29125)
-- Name: DATA_STRUCTURE_ATTRIBUTES FK_DATA_STRUCTURE_ATTRIBUTES; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_ATTRIBUTES"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_ATTRIBUTES" FOREIGN KEY (data_structure_urn) REFERENCES public."DATA_STRUCTURE"(urn);


--
-- TOC entry 3914 (class 2606 OID 29130)
-- Name: DATA_STRUCTURE_ATTRIBUTES FK_DATA_STRUCTURE_ATTRIBUTES_CODE_LIST; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_ATTRIBUTES"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_ATTRIBUTES_CODE_LIST" FOREIGN KEY (code_list_urn) REFERENCES public."CODE_LIST"(urn);


--
-- TOC entry 3915 (class 2606 OID 29135)
-- Name: DATA_STRUCTURE_ATTRIBUTES FK_DATA_STRUCTURE_ATTRIBUTES_CONCEPT; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_ATTRIBUTES"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_ATTRIBUTES_CONCEPT" FOREIGN KEY (concept_identity_urn) REFERENCES public."CONCEPT_SCHEME_CONCEPTS"(urn);


--
-- TOC entry 3916 (class 2606 OID 53545)
-- Name: DATA_STRUCTURE_ATTRIBUTES FK_DATA_STRUCTURE_ATTRIBUTES_DATA_STRUCTURE_MEASURE; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_ATTRIBUTES"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_ATTRIBUTES_DATA_STRUCTURE_MEASURE" FOREIGN KEY (data_structure_measure_urn) REFERENCES public."DATA_STRUCTURE_MEASURE"(urn) NOT VALID;


--
-- TOC entry 3907 (class 2606 OID 29078)
-- Name: DATA_STRUCTURE_DIMENSIONS FK_DATA_STRUCTURE_DIMENSION; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_DIMENSIONS"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_DIMENSION" FOREIGN KEY (data_structure_urn) REFERENCES public."DATA_STRUCTURE"(urn);


--
-- TOC entry 3909 (class 2606 OID 29088)
-- Name: DATA_STRUCTURE_DIMENSIONS FK_DATA_STRUCTURE_DIMENSION_CODE_LIST; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_DIMENSIONS"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_DIMENSION_CODE_LIST" FOREIGN KEY (code_list_urn) REFERENCES public."CODE_LIST"(urn);


--
-- TOC entry 3908 (class 2606 OID 29083)
-- Name: DATA_STRUCTURE_DIMENSIONS FK_DATA_STRUCTURE_DIMENSION_CONCEPT; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_DIMENSIONS"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_DIMENSION_CONCEPT" FOREIGN KEY (concept_scheme_urn) REFERENCES public."CONCEPT_SCHEME_CONCEPTS"(urn);


--
-- TOC entry 3917 (class 2606 OID 29148)
-- Name: DATA_STRUCTURE_MEASURE FK_DATA_STRUCTURE_MEASURE; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_MEASURE"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_MEASURE" FOREIGN KEY (data_structure_urn) REFERENCES public."DATA_STRUCTURE"(urn);


--
-- TOC entry 3918 (class 2606 OID 29153)
-- Name: DATA_STRUCTURE_MEASURE FK_DATA_STRUCTURE_MEASURE_CODE_LIST; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_MEASURE"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_MEASURE_CODE_LIST" FOREIGN KEY (code_list_urn) REFERENCES public."CODE_LIST"(urn);


--
-- TOC entry 3919 (class 2606 OID 29158)
-- Name: DATA_STRUCTURE_MEASURE FK_DATA_STRUCTURE_MEASURE_CONCEPT; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_MEASURE"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_MEASURE_CONCEPT" FOREIGN KEY (concept_identity_urn) REFERENCES public."CONCEPT_SCHEME_CONCEPTS"(urn);


--
-- TOC entry 3910 (class 2606 OID 29101)
-- Name: DATA_STRUCTURE_TIME_DIMENSIONS FK_DATA_STRUCTURE_TIME_DIMENSION; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_TIME_DIMENSIONS"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_TIME_DIMENSION" FOREIGN KEY (data_structure_urn) REFERENCES public."DATA_STRUCTURE"(urn);


--
-- TOC entry 3911 (class 2606 OID 29106)
-- Name: DATA_STRUCTURE_TIME_DIMENSIONS FK_DATA_STRUCTURE_TIME_DIMENSION_CODE_LIST; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_TIME_DIMENSIONS"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_TIME_DIMENSION_CODE_LIST" FOREIGN KEY (code_list_urn) REFERENCES public."CODE_LIST"(urn);


--
-- TOC entry 3912 (class 2606 OID 29111)
-- Name: DATA_STRUCTURE_TIME_DIMENSIONS FK_DATA_STRUCTURE_TIME_DIMENSION_CONCEPT; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DATA_STRUCTURE_TIME_DIMENSIONS"
    ADD CONSTRAINT "FK_DATA_STRUCTURE_TIME_DIMENSION_CONCEPT" FOREIGN KEY (concept_identity_urn) REFERENCES public."CONCEPT_SCHEME_CONCEPTS"(urn);


-- Completed on 2023-03-09 15:37:52 CET

--
-- PostgreSQL database dump complete
--

